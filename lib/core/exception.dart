// General
class DataSourceException implements Exception {}

class LocalDataSourceException implements Exception {}

// API-related
class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

// Cache-related
class CacheException implements Exception {
  final String message;
  CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}
