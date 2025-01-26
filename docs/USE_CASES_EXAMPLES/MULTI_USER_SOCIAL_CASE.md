# Multi-User Social Case with **upper_flutter_stores**

This guide demonstrates how to use the **upper_flutter_stores** package to build a scalable, performant, and user-friendly multi-user social application. The goal is to maintain simplicity while leveraging the package's features for efficient state management and reactivity.

---

## **Features in Focus**
- Multi-store support for managing users, posts, and comments.
- Persistence for saving and restoring data across sessions.
- Middleware for logging and validation.
- Snapshots and replay for debugging complex state transitions.
- Undo/Redo for managing user interactions (e.g., editing posts).

---

## **Architecture Overview**

### **Folder Structure**
```plaintext
lib/
├── main.dart
├── features/
│   ├── auth/
│   │   ├── store/
│   │   │   └── user_store.dart
│   │   └── screens/
│   │       └── login_screen.dart
│   ├── posts/
│   │   ├── store/
│   │   │   └── post_store.dart
│   │   └── screens/
│   │       ├── post_list_screen.dart
│   │       ├── post_detail_screen.dart
│   │       └── create_post_screen.dart
│   ├── comments/
│   │   ├── store/
│   │   │   └── comment_store.dart
│   │   └── screens/
│   │       └── comment_list_screen.dart
├── common/
│   ├── widgets/
│   │   ├── loading_indicator.dart
│   │   └── error_message.dart
│   ├── utils/
│   │   └── validators.dart
└── app.dart
```

---

## **Implementation**

### **1. Setting Up Stores**

#### **User Store**
Tracks logged-in user data and authentication status.

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
        ){
    initializePersistence();
  }

  Map<String, dynamic>? get user => state['user'];
  bool get isLoggedIn => state['isLoggedIn'] ?? false;

  void login(Map<String, dynamic> userData) {
    set({
      'user': userData,
      'isLoggedIn': true,
    });
  }

  void logout() {
    set({
      'user': null,
      'isLoggedIn': false,
    });
  }
}
```

#### **Post Store**
Manages posts, including creation, updates, and deletion.

```dart
class PostStore extends StoreInterface<List<Map<String, dynamic>>> {
  PostStore()
      : super(
          [],
          enableUndoRedo: true,
          enableSnapshots: true,
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get posts => state;

  void addPost(Map<String, dynamic> post) {
    set([...state, post]);
  }

  void updatePost(int index, Map<String, dynamic> updatedPost) {
    final updatedPosts = List<Map<String, dynamic>>.from(state);
    updatedPosts[index] = updatedPost;
    set(updatedPosts);
  }

  void removePost(int index) {
    final updatedPosts = List<Map<String, dynamic>>.from(state)..removeAt(index);
    set(updatedPosts);
  }
}
```

#### **Comment Store**
Manages comments for posts.

```dart
class CommentStore extends StoreInterface<Map<int, List<Map<String, dynamic>>>> {
  CommentStore()
      : super(
          {},
          enablePersistence: true,
          persistKey: 'comment_store',
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> getComments(int postId) => state[postId] ?? [];

  void addComment(int postId, Map<String, dynamic> comment) {
    final updatedComments = {
      ...state,
      postId: [...getComments(postId), comment],
    };
    set(updatedComments);
  }

  void removeComment(int postId, int index) {
    final updatedPostComments = List<Map<String, dynamic>>.from(getComments(postId))
      ..removeAt(index);
    set({
      ...state,
      postId: updatedPostComments,
    });
  }
}
```

---

### **2. Building the UI**

#### **Post List Screen**
Displays all posts.

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/post_store.dart';

class PostListScreen extends StatelessWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: StoreConsumer<PostStore>(
        builder: (context, postStore) {
          final posts = postStore.posts;
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post['title'] ?? ''),
                subtitle: Text(post['content'] ?? ''),
                onTap: () {},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

---

### **3. MultiStoreProvider Setup**

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'features/auth/store/user_store.dart';
import 'features/posts/store/post_store.dart';
import 'features/comments/store/comment_store.dart';
import 'features/posts/screens/post_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiStoreProvider(
      definitions: [
        StoreDefinition(UserStore()),
        StoreDefinition(PostStore()),
        StoreDefinition(CommentStore()),
      ],
      child: MaterialApp(
        title: 'Social App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const PostListScreen(),
      ),
    );
  }
}
```

---

### **Best Practices**
1. **Use Models**: Define models for posts, users, and comments for type safety and consistency.
2. **Keep Stores Focused**: Each store should manage only one type of data or logic.
3. **Leverage Middleware**: Add logging or analytics via middleware.
4. **Snapshots for Debugging**: Use snapshots to debug state changes during development.
5. **Persistence for Key Data**: Persist critical data like user sessions and comments.

---

With this setup, you can build a multi-user social application that is performant, easy to manage, and scalable without overcomplication.
