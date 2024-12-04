# Local State

## Motivation

When managing local state, especially combining it with global state, which tends to be retrieved from `InheritedWidget` or some replacement like Riverpod, we need to **mix** them inside `build()` method.

```dart
/// we need `ConsumerStatefulWidget` because we need both global and local states
class SomeWidget extends ConsumerStatefulWidget {
  const SomeWidget({super.key});

  @override
  ConsumerState<SomeWidget> createState() => _SomeWidgetState();
}

class _SomeWidgetState extends ConsumerState<SomeWidget> {
  // local state
  bool _isFiltered = false;

  @override
  Widget build(BuildContext context) {
    // retrieve all the data from global state
    final allArticles = ref.watch(articlesProvider);

    // filter the data considering the local state
    final filteredArticles = allArticles.where((article) => article.isPublished).toList();

    return ListView.builder(
      // use filtered data calculated inside `build()` method
      itemCount: filteredArticles.length,
      itemBuilder: (context, index) => Text(filteredArticles[index].title),
    );
  }
}
```

This usually works in most cases. However, once the calculation becomes more complex, the `build()` method will soon become messy and hard to find how widget tree is built.

We may want to keep `build()` method focus on the points below:

- What widgets are used and how they build widget tree
- What data it depends on, meaning what data affects UI and when rebuilds happen.

Because Flutter hires _declarative_ UI building, all the dependencies should be clearly stated in `build()` method.

And also, the _complex_ logic should be tested independently, ideally with unit tests, not widget tests.

## Solution

One solution I'll introduce here is to make a `ViewState` class which:

- is independent from Flutter
- is immutable
- exposes calculated data as `late final` fields or getters

Using this idea, the previous example can be rewritten like below:

```dart
class SomeViewState {
  final List<Article> articles;
  final bool isFiltered;

  late final List<Article> filteredArticles = allArticles.where((article) => article.isPublished).toList();

}
```

```dart
/// we need `ConsumerStatefulWidget` because we need both global and local states
class SomeWidget extends ConsumerStatefulWidget {
  const SomeWidget({super.key});

  @override
  ConsumerState<SomeWidget> createState() => _SomeWidgetState();
}

class _SomeWidgetState extends ConsumerState<SomeWidget> {
  // local state
  bool _isFiltered = false;

  @override
  Widget build(BuildContext context) {
    // create view state object using global state and local state
    final viewState = SomeViewState(
      articles: ref.watch(articlesProvider),
      isFiltered: _isFiltered,
    );

    return ListView.builder(
      // use filtered data calculated inside `build()` method
      itemCount: viewState.filteredArticles.length,
      itemBuilder: (context, index) => Text(viewState.filteredArticles[index].title),
    );
  }
}
```

Although this doesn't look like much of an improvement, we can find the benefits below:

- `build()` method now contains only the code of retrieving data and building widget tree.
- the logic to make `filteredArticles` is extracted to `SomeViewState` class, which can be easily tested with unit tests.

The test code look like below.

```dart
void main() {
  test('filteredArticles should return only published articles when isFiltered is true', () {
    final articles = [
      Article(title: 'Article 1', isPublished: true),
      Article(title: 'Article 2', isPublished: false),
      Article(title: 'Article 3', isPublished: true),
    ];
    
    final viewState = SomeViewState(
      articles: articles,
      isFiltered: true,
    );

    expect(viewState.filteredArticles.length, 2);
    expect(viewState.filteredArticles.every((article) => article.isPublished), true);
  });
}
```

## Do / Don't

### 1. Keep ViewState immutable

Because the key concept of Flutter is _Declarative_, UI must be rebuilt when the state changes.

If the ViewState is mutable, the UI may miss the opportunity to rebuild.

```dart
class SomeViewState {
  List<Article> articles;
  bool isFiltered;

  SomeViewState({required this.articles, required this.isFiltered});

  void toggleFilter() {
    // this doesn't happen rebuilding, and programmer may forget to call 
    // some other mechanism to cause rebuilding (e.g. setState())
    isFiltered = !isFiltered;
  }
}
```

### 2. Don't introduce `BuildContext` to ViewState

Sometimes, you may want to introduce `BuildContext` to ViewState to retrieve some data from global state to prevent `build()` method from becoming messy.

However, this reveals not only the complex logic from `build()` method but also exact dependency on global states.

Knowing the exact dependency on global states is important to manage what data affects UI and when rebuilds happen, so source codes to depend on global states should be left in `build()` method.

In addition, `BuildContext` the class is impossible to be tested with unit test, which means the ViewState class must be tested with widget test together with its corresponding widget.

### 3. Distinguish between local state and global state

Global state and local state have totally different concepts.

Global state is possibly dependent from multiple widgets, while local state is independent from other widgets.

Also, the method to retrieve global state is different from that to retrieve local state. Global state are referenced through `InheritedWidget` or other state management packages, while local state are managed inside `StatefulWidget` itself.

Don't introduce `InheritedWidget` or `Provider` of Riverpod to manage local state, or you and team members will get confused whether the state are globally shared or occupied only in the widget itself.

### 4. Don't use ViewState _in all cases_

This ViewState is required only when the global state or local state can't be used for UI as-is. 

The biggest benefit of this pattern is to extract the logic to calculate data for UI, which means the pattern is not required unless the logic is complex and required to be tested independently.

The downside of this pattern is introducing an additional class which potentially makes it difficult to read and understand the entire code related to the corresponding widget.

### 5. Don't introduce this pattern as a part of an architecture

This pattern is not a part of an architecture, but just a technique to manage complex local state.

Therefore, don't introduce this pattern as a part of an architecture. This pattern easily cause more confusion than benefits.
