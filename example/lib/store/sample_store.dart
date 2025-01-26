import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class SampleStore extends StoreInterface<Map<String, dynamic>> {
  SampleStore()
      : super(
          {'sampleData': 'Hello multistore!'},
          enableDebugging: true,
        ) {
    initializePersistence();
  }

  String get sampleData {
    final data = state['sampleData'];
    if (enableDebugging) {
      print('SampleStore: Retrieved sampleData: $data');
    }
    return data ?? 'No Data';
  }

  void updateSampleData(String newData) {
    if (enableDebugging) {
      print('SampleStore: Updating sampleData to: $newData');
    }
    set({'sampleData': newData});
  }
}
