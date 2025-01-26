# Uber-like App Use Case with **upper_flutter_stores**

This document demonstrates how to utilize the **upper_flutter_stores** package to build an Uber-like app. The focus is on performance, ease of use, and avoiding overengineering while ensuring a clean and maintainable architecture.

---

## Key Features to Implement

1. **Real-time Updates**:
   - Live location tracking for drivers and passengers.
   - Dynamic ride status updates.

2. **Persistence**:
   - Save ride data locally to ensure continuity in case of app restarts.

3. **Undo/Redo**:
   - Allow operators or admins to undo or redo actions such as ride cancellations.

4. **Multi-Store Setup**:
   - Separate stores for different domains (e.g., user, ride, driver, settings).

5. **Middleware**:
   - Log critical state changes for debugging and analytics.

---

## Suggested Folder Structure

```
lib/
├── main.dart
├── features/
│   ├── user/
│   │   ├── store/
│   │   │   └── user_store.dart
│   │   ├── screens/
│   │   │   └── user_profile_screen.dart
│   ├── ride/
│   │   ├── store/
│   │   │   └── ride_store.dart
│   │   ├── screens/
│   │   │   └── ride_tracking_screen.dart
│   ├── driver/
│   │   ├── store/
│   │   │   └── driver_store.dart
│   │   ├── screens/
│   │   │   └── driver_dashboard_screen.dart
├── common/
│   ├── widgets/
│   ├── utils/
│   └── themes/
└── services/
    ├── api_service.dart
    └── location_service.dart
```

---

## Step-by-Step Implementation

### 1. **User Store**

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class UserStore extends StoreInterface<Map<String, dynamic>> {
  UserStore()
      : super(
          {
            'user': null,
            'isLoggedIn': false,
          },
          enablePersistence: true,
          persistKey: 'user_store',
        ) {
    initializePersistence();
  }

  Map<String, dynamic>? get user => state['user'];
  bool get isLoggedIn => state['isLoggedIn'] ?? false;

  void login(Map<String, dynamic> userData) {
    set({'user': userData, 'isLoggedIn': true});
  }

  void logout() {
    set({'user': null, 'isLoggedIn': false});
  }
}
```

### 2. **Ride Store**

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class RideStore extends StoreInterface<Map<String, dynamic>> {
  RideStore()
      : super(
          {
            'currentRide': null,
            'rideHistory': [],
          },
          enableUndoRedo: true,
          enableSnapshots: true,
          enablePersistence: true,
          persistKey: 'ride_store',
        ) {
    initializePersistence();
  }

  Map<String, dynamic>? get currentRide => state['currentRide'];
  List<Map<String, dynamic>> get rideHistory => List<Map<String, dynamic>>.from(state['rideHistory']);

  void startRide(Map<String, dynamic> rideData) {
    set({'currentRide': rideData, 'rideHistory': rideHistory});
  }

  void completeRide() {
    final updatedHistory = [...rideHistory, currentRide];
    set({'currentRide': null, 'rideHistory': updatedHistory});
  }
}
```

### 3. **Driver Store**

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class DriverStore extends StoreInterface<Map<String, dynamic>> {
  DriverStore()
      : super(
          {
            'drivers': [],
            'onlineDrivers': [],
          },
          enableSnapshots: true,
        );

  List<Map<String, dynamic>> get drivers => List<Map<String, dynamic>>.from(state['drivers']);
  List<Map<String, dynamic>> get onlineDrivers => List<Map<String, dynamic>>.from(state['onlineDrivers']);

  void addDriver(Map<String, dynamic> driver) {
    set({'drivers': [...drivers, driver], 'onlineDrivers': onlineDrivers});
  }

  void setDriverOnline(int driverId) {
    final updatedOnlineDrivers = [...onlineDrivers, driverId];
    set({'drivers': drivers, 'onlineDrivers': updatedOnlineDrivers});
  }
}
```

---

## MultiStoreProvider Setup

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'features/user/store/user_store.dart';
import 'features/ride/store/ride_store.dart';
import 'features/driver/store/driver_store.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition(UserStore()),
        StoreDefinition(RideStore()),
        StoreDefinition(DriverStore()),
      ],
      child: MaterialApp(
        title: 'Uber-like App',
        home: HomeScreen(),
      ),
    );
  }
}
```

---

## Key Screens

### 1. **Ride Tracking Screen**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/ride_store.dart';

class RideTrackingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConsumer<RideStore>(
      builder: (context, rideStore) {
        final ride = rideStore.currentRide;

        return Scaffold(
          appBar: AppBar(title: Text('Ride Tracking')),
          body: ride == null
              ? Center(child: Text('No active ride.'))
              : Column(
                  children: [
                    Text('Ride ID: ${ride['id']}'),
                    Text('Status: ${ride['status']}'),
                  ],
                ),
        );
      },
    );
  }
}
```

### 2. **Driver Dashboard**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/driver_store.dart';

class DriverDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConsumer<DriverStore>(
      builder: (context, driverStore) {
        final drivers = driverStore.onlineDrivers;

        return Scaffold(
          appBar: AppBar(title: Text('Driver Dashboard')),
          body: ListView.builder(
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return ListTile(
                title: Text('Driver ID: $driver'),
              );
            },
          ),
        );
      },
    );
  }
}
```

---

## Conclusion

By leveraging **upper_flutter_stores**, this Uber-like app demonstrates how to achieve high performance and maintainability while keeping the codebase simple and user-friendly. The package's unified store approach, combined with features like persistence, undo/redo, and snapshots, ensures an efficient development process tailored to real-world needs.
