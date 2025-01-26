# AsyncStore

The **AsyncStore** provides built-in support for managing asynchronous tasks while maintaining state consistency. This store is useful for operations such as fetching data from a remote API or performing long-running calculations.

#### Features of AsyncStore

- Built-in support for asynchronous operations.
- Automatically updates state based on the outcome of asynchronous tasks.
- Provides a state object for monitoring the current status (`loading`, `data`, or `error`).

#### Constructor

```dart
AsyncStore({
  bool enableDebugging = false,
  String? debugContext,
})
```

- `enableDebugging`: Enables debug logs to provide insights into the state changes during asynchronous operations.
- `debugContext`: Adds contextual information for debugging.

#### AsyncState Object

The `AsyncState` object provides the current state of the asynchronous operation. It contains the following properties:

- `loading`: A `bool` indicating whether the task is in progress.
- `data`: The result of the completed task (if successful).
- `error`: The error object (if the task fails).

#### Methods

- `run(Future<T> Function() task)`: Executes an asynchronous task and updates the state based on its progress.
  - `task`: A function that returns a `Future`.

#### Usage Example

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class WeatherStore extends AsyncStore<Map<String, dynamic>> {
  WeatherStore() : super(enableDebugging: true, debugContext: 'WeatherStore');

  Future<void> fetchWeather() async {
    await run(() async {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      return {
        'temperature': '20°C',
        'condition': 'Cloudy',
      };
    });
  }

  Map<String, dynamic>? get weatherData => state.data;

  bool get isLoading => state.loading;

  dynamic get error => state.error;
}

void main() {
  final weatherStore = WeatherStore();

  weatherStore.fetchWeather();
}
```

#### State Monitoring

To observe state changes and update the UI:

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class WeatherScreen extends StatelessWidget {
  final WeatherStore weatherStore = WeatherStore();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: weatherStore,
      builder: (context, _, __) {
        if (weatherStore.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (weatherStore.error != null) {
          return Center(child: Text('Error: ${weatherStore.error}'));
        } else {
          final data = weatherStore.weatherData;
          return Center(
            child: Text(
              'Temperature: ${data?['temperature']}, Condition: ${data?['condition']}',
            ),
          );
        }
      },
    );
  }
}
```

The **AsyncStore** simplifies asynchronous operations by managing the loading, success, and error states transparently. This ensures a seamless developer experience for handling dynamic, data-driven applications.
