# WAZE-Style Navigation App Case Study

This guide demonstrates how to use the `upper_flutter_stores` package to build a high-performance, Waze-like navigation application. By adhering to the package's philosophy of simplicity, scalability, and minimal boilerplate, we ensure a clean and maintainable architecture.

---

## **Features of a Waze-Style App**
1. **Real-Time Location Updates**
2. **Traffic Conditions and Alerts**
3. **Route Optimization**
4. **Community Contributions** (e.g., hazard reports)
5. **User Authentication**
6. **Offline Mode**

---

## **Architecture Overview**

### **Folder Structure**
```
lib/
├── main.dart
├── features/
│   ├── navigation/
│   │   ├── screens/
│   │   │   ├── map_screen.dart
│   │   │   ├── route_preview_screen.dart
│   │   ├── store/
│   │   │   ├── location_store.dart
│   │   │   ├── traffic_store.dart
│   │   │   ├── route_store.dart
│   │   │   └── alerts_store.dart
│   │   ├── services/
│   │   │   ├── traffic_service.dart
│   │   │   ├── route_service.dart
│   │   │   └── location_service.dart
│   │   ├── models/
│   │   │   ├── location_model.dart
│   │   │   ├── route_model.dart
│   │   │   └── alert_model.dart
├── common/
│   ├── widgets/
│   ├── utils/
│   └── themes/
```

---

## **Step-by-Step Implementation**

### **1. State Management**

#### **Location Store**
- Handles real-time user location updates.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class LocationStore extends StoreInterface<Map<String, dynamic>> {
  LocationStore()
      : super(
          {
            'latitude': 0.0,
            'longitude': 0.0,
          },
          enablePersistence: true,
          persistKey: 'location_store',
        ){
    initializePersistence();
  }

  void updateLocation(double latitude, double longitude) {
    set({'latitude': latitude, 'longitude': longitude});
  }

  Map<String, double> get location => {
        'latitude': state['latitude'],
        'longitude': state['longitude'],
      };
}
```

#### **Traffic Store**
- Manages traffic updates and conditions.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class TrafficStore extends StoreInterface<List<Map<String, dynamic>>> {
  TrafficStore() : super([], enableSnapshots: true);

  void updateTraffic(List<Map<String, dynamic>> trafficConditions) {
    set(trafficConditions);
  }

  List<Map<String, dynamic>> get trafficData => state;
}
```

#### **Route Store**
- Handles route optimization and previews.

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class RouteStore extends StoreInterface<Map<String, dynamic>> {
  RouteStore() : super({'route': [], 'estimatedTime': 0});

  void setRoute(List<Map<String, dynamic>> route, int estimatedTime) {
    set({'route': route, 'estimatedTime': estimatedTime});
  }

  Map<String, dynamic> get routeInfo => state;
}
```

---

### **2. UI Implementation**

#### **Map Screen**
Displays the map, real-time user location, and traffic data.

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/location_store.dart';
import '../store/traffic_store.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: StoreProvider.of<LocationStore>(context),
              builder: (context, locationStore, _) {
                final location = locationStore.location;
                return Center(
                  child: Text(
                    'Location: ${location['latitude']}, ${location['longitude']}',
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: StoreProvider.of<TrafficStore>(context),
              builder: (context, trafficStore, _) {
                final traffic = trafficStore.trafficData;
                return ListView.builder(
                  itemCount: traffic.length,
                  itemBuilder: (context, index) {
                    final condition = traffic[index];
                    return ListTile(
                      title: Text(condition['description']),
                      subtitle: Text('Severity: ${condition['severity']}'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### **3. Services**

#### **Traffic Service**
Fetches traffic data from an API.

```dart
class TrafficService {
  Future<List<Map<String, dynamic>>> fetchTrafficData() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));
    return [
      {'description': 'Heavy traffic on I-95', 'severity': 'High'},
      {'description': 'Accident on Route 66', 'severity': 'Moderate'},
    ];
  }
}
```

---

## **Best Practices**
1. **Minimize Boilerplate**:
   Use `StoreProvider` and `StoreConsumer` to simplify state management in the widget tree.
2. **Optimize Performance**:
   Leverage snapshots and avoid unnecessary updates to unrelated widgets.
3. **Scalable Design**:
   Organize features into modular folders with dedicated stores, services, and models.

---

By following this approach, you can build a high-performance, Waze-like navigation app with minimal effort while ensuring scalability and maintainability.
