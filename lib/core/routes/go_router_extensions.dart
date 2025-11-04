import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoNoDup on BuildContext {
  bool _sameUri(Uri a, Uri b) =>
      a.path == b.path && a.query == b.query && a.fragment == b.fragment;

  void goIfNotCurrent(String location, {Object? extra}) {
    final current = GoRouterState.of(this).uri;
    final target = Uri.parse(location);
    if (_sameUri(current, target)) return;
    go(location, extra: extra); // go supports `extra`
  }

  Future<T?> pushIfNotCurrent<T extends Object?>(String location, {Object? extra}) {
    final current = GoRouterState.of(this).uri;
    final target = Uri.parse(location);
    if (_sameUri(current, target)) return Future.value(null);
    return push<T>(location, extra: extra); // push supports `extra`
  }

  void goNamedIfNotCurrent(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? fragment,
    Object? extra,
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
    goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  Future<T?> pushNamedIfNotCurrent<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const {},
    Map<String, String> queryParameters = const {},
    String? fragment,
    Object? extra,
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
      extra: extra,
    );
  }
}
