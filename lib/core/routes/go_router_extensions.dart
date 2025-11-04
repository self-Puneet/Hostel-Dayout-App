import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoNoDup on BuildContext {
  bool _sameUri(Uri a, Uri b) =>
      a.path == b.path && a.query == b.query && a.fragment == b.fragment;

  // Use for top-level destinations (tabs/home) so you don't grow the stack.
  void goIfNotCurrent(String location) {
    final current = GoRouterState.of(this).uri;
    final target = Uri.parse(location);
    if (_sameUri(current, target)) return;
    go(location);
  }

  // Use for secondary/detail pages; still guard duplicates.
  Future<T?> pushIfNotCurrent<T extends Object?>(String location) {
    final current = GoRouterState.of(this).uri;
    final target = Uri.parse(location);
    if (_sameUri(current, target)) return Future.value(null);
    return push<T>(location);
  }

  // Prefer named APIs to get canonical locations (handles params/query uniformly).
  void goNamedIfNotCurrent(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? fragment,
  }) {
    final router = GoRouter.of(this);
    final current = GoRouterState.of(this).uri;
    final loc = router.namedLocation(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      fragment: fragment,
    );
    final target = Uri.parse(loc);
    if (_sameUri(current, target)) return;
    go(loc);
  }

  Future<T?> pushNamedIfNotCurrent<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? fragment,
  }) {
    final router = GoRouter.of(this);
    final current = GoRouterState.of(this).uri;
    final loc = router.namedLocation(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      fragment: fragment,
    );
    final target = Uri.parse(loc);
    if (_sameUri(current, target)) return Future.value(null);
    return pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: null,
    );
  }
}
