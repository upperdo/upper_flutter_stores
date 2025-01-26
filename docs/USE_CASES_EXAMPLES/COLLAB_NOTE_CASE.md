# Note Collaboration Case Study

This case study demonstrates how to use the **upper\_flutter\_stores** package to build a simple and collaborative note-taking application. The solution prioritizes performance, ease of use, and minimal complexity while leveraging the features of **upper\_flutter\_stores** to manage state efficiently.

---

## Objective

Build a collaborative note-taking app where multiple users can:

1. Create, edit, and delete notes.
2. See real-time updates from other users.
3. Persist notes across sessions.
4. Undo/Redo changes to notes.

---

## Folder Structure

A suggested folder structure for clarity and maintainability:

```
lib/
├── main.dart
├── features/
│   ├── note/
│   │   ├── models/
│   │   │   └── note_model.dart
│   │   ├── store/
│   │   │   └── note_store.dart
│   │   ├── services/
│   │   │   └── collaboration_service.dart
│   │   ├── screens/
│   │   │   ├── note_list_screen.dart
│   │   │   └── note_detail_screen.dart
├── common/
│   ├── widgets/
│   │   ├── note_card.dart
│   │   └── note_editor.dart
│   ├── utils/
└── themes/
```

---

## Implementation

### Step 1: Define the Note Model

Create a model to represent notes.

**File:** `lib/features/note/models/note_model.dart`

```dart
class Note {
  final String id;
  String title;
  String content;

  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
      };

  static Note fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }
}
```

---

### Step 2: Create the Note Store

Leverage **upper\_flutter\_stores** to manage the notes' state.

**File:** `lib/features/note/store/note_store.dart`

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../models/note_model.dart';

class NoteStore extends StoreInterface<Map<String, List<Note>>> {
  NoteStore()
      : super(
          {'notes': []},
          enablePersistence: true,
          persistKey: 'note_store',
          fromJson: (json) => {'notes': (json['notes'] as List<dynamic>).map((e) => Note.fromJson(e)).toList()},
          toJson: (state) => {'notes': state['notes']?.map((note) => note.toJson()).toList()},
        ){
    initializePersistence();
  }

  List<Note> get notes => state['notes'] ?? [];

  void addNote(Note note) {
    set({'notes': [...notes, note]});
  }

  void updateNote(Note updatedNote) {
    set({
      'notes': notes.map((note) => note.id == updatedNote.id ? updatedNote : note).toList(),
    });
  }

  void deleteNote(String id) {
    set({
      'notes': notes.where((note) => note.id != id).toList(),
    });
  }
}
```

---

### Step 3: Create the Collaboration Service

A mock collaboration service to simulate real-time updates.

**File:** `lib/features/note/services/collaboration_service.dart`

```dart
class CollaborationService {
  final NoteStore store;

  CollaborationService(this.store);

  void simulateIncomingUpdate(Note note) {
    store.updateNote(note);
  }
}
```

---

### Step 4: Build the UI

#### Note List Screen

Display the list of notes.

**File:** `lib/features/note/screens/note_list_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../store/note_store.dart';
import 'note_detail_screen.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteStore = StoreProvider.of<NoteStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: ValueListenableBuilder(
        valueListenable: noteStore,
        builder: (context, _, __) {
          final notes = noteStore.notes;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return ListTile(
                title: Text(note.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteDetailScreen(note: note),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          noteStore.addNote(Note(
            id: DateTime.now().toString(),
            title: 'New Note',
            content: '',
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

#### Note Detail Screen

Edit or delete a specific note.

**File:** `lib/features/note/screens/note_detail_screen.dart`

```dart
import 'package:flutter/material.dart';
import '../store/note_store.dart';
import '../models/note_model.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noteStore = StoreProvider.of<NoteStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              noteStore.deleteNote(note.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: note.title),
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                note.title = value;
                noteStore.updateNote(note);
              },
            ),
            TextField(
              controller: TextEditingController(text: note.content),
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 10,
              onChanged: (value) {
                note.content = value;
                noteStore.updateNote(note);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Conclusion

The `upper_flutter_stores` package simplifies state management, enabling you to:

1. Manage complex state efficiently.
2. Reduce boilerplate with clear APIs.
3. Implement advanced features like undo/redo, snapshots, and persistence effortlessly.

This example showcases the flexibility and power of `upper_flutter_stores`, empowering you to create performant, scalable, and maintainable applications without overengineering.
