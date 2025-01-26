# Instagram-Like App Case

This guide demonstrates how to use the **upper_flutter_stores** package to build an Instagram-like app, focusing on performance, simplicity, and avoiding overengineering.

---

## Key Features to Implement

1. **Feed Management**:
   - Display posts in a scrollable list.
   - Support infinite scrolling.
   - Allow users to like and comment on posts.

2. **User Profiles**:
   - Show user details and their posts.
   - Allow editing profile information.

3. **Post Creation**:
   - Users can upload photos and videos.
   - Add captions and tags.

4. **Notifications**:
   - Real-time updates for likes, comments, and follows.

5. **Search Functionality**:
   - Search for users, posts, or hashtags.

6. **Authentication**:
   - Login and registration functionality.

---

## Folder Structure

```
lib/
├── main.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── store/
│   │   │   └── auth_store.dart
│   ├── feed/
│   │   ├── screens/
│   │   │   ├── feed_screen.dart
│   │   │   └── post_details_screen.dart
│   │   ├── store/
│   │   │   └── feed_store.dart
│   ├── profile/
│   │   ├── screens/
│   │   │   ├── profile_screen.dart
│   │   │   └── edit_profile_screen.dart
│   │   ├── store/
│   │   │   └── profile_store.dart
│   ├── search/
│   │   ├── screens/
│   │   │   └── search_screen.dart
│   │   ├── store/
│   │   │   └── search_store.dart
│   ├── notifications/
│   │   ├── screens/
│   │   │   └── notifications_screen.dart
│   │   ├── store/
│   │   │   └── notifications_store.dart
├── common/
│   ├── widgets/
│   ├── utils/
│   └── themes/
```

---

## Example: Feed Feature

### 1. Create the Feed Store

**File:** `features/feed/store/feed_store.dart`

```dart
import 'package:upper_flutter_stores/upper_flutter_stores.dart';

class FeedStore extends StoreInterface<Map<String, dynamic>> {
  FeedStore()
      : super(
          {
            'posts': [],
            'nextPage': 1,
            'isLoading': false,
          },
          enableAsync: true,
          enableDebugging: true,
        ){
    initializePersistence();
  }

  List<Map<String, dynamic>> get posts => List<Map<String, dynamic>>.from(state['posts'] ?? []);
  int get nextPage => state['nextPage'] ?? 1;
  bool get isLoading => state['isLoading'] ?? false;

  Future<void> loadPosts() async {
    if (isLoading) return;

    set({ ...state, 'isLoading': true });

    try {
      // Simulate API call
      final newPosts = List.generate(10, (index) => {
        'id': nextPage * 10 + index,
        'content': 'Post content #${nextPage * 10 + index}',
        'likes': 0,
        'comments': 0,
      });

      set({
        ...state,
        'posts': [...posts, ...newPosts],
        'nextPage': nextPage + 1,
        'isLoading': false,
      });
    } catch (e) {
      set({ ...state, 'isLoading': false });
      print('Failed to load posts: $e');
    }
  }

  void likePost(int postId) {
    final updatedPosts = posts.map((post) {
      if (post['id'] == postId) {
        return { ...post, 'likes': (post['likes'] ?? 0) + 1 };
      }
      return post;
    }).toList();

    set({ ...state, 'posts': updatedPosts });
  }
}
```

### 2. Create the Feed Screen

**File:** `features/feed/screens/feed_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import '../store/feed_store.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final feedStore = StoreProvider.of<FeedStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ValueListenableBuilder(
        valueListenable: feedStore,
        builder: (context, _, __) {
          final posts = feedStore.posts;

          return ListView.builder(
            itemCount: posts.length + 1,
            itemBuilder: (context, index) {
              if (index == posts.length) {
                feedStore.loadPosts();
                return const Center(child: CircularProgressIndicator());
              }

              final post = posts[index];

              return ListTile(
                title: Text(post['content'] ?? ''),
                subtitle: Text('${post['likes']} likes'),
                trailing: IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () => feedStore.likePost(post['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

### 3. Integrate the Feed Store

**File:** `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:upper_flutter_stores/upper_flutter_stores.dart';
import 'features/feed/store/feed_store.dart';
import 'features/feed/screens/feed_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<FeedStore>(
      store: FeedStore(),
      child: MaterialApp(
        home: const FeedScreen(),
      ),
    );
  }
}
```

---

## Additional Features

### Notifications
Use `SnapshotStore` to capture and replay user interactions for notifications.

### Authentication
Integrate `PersistentStore` to manage user sessions and ensure persistence across app restarts.

### Profiles
Encapsulate profile management logic within a `ProfileStore` for clean separation.

---

By following this guide, you can efficiently implement an Instagram-like app with performance and simplicity at its core, adhering to the philosophy of the **upper_flutter_stores** package.
