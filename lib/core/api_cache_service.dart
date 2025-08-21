class ApiCacheService {
  static final ApiCacheService _instance = ApiCacheService._internal();
  factory ApiCacheService() => _instance;
  ApiCacheService._internal();

  final Map<String, CacheEntry> _cache = {};
  static const Duration _defaultCacheDuration = Duration(minutes: 5);
  static const Duration _rateLimitCacheDuration = Duration(minutes: 15);

  void _cleanExpiredEntries() {
    final now = DateTime.now();
    _cache.removeWhere((key, entry) => entry.isExpired(now));
  }

  String _generateKey(String endpoint, Map<String, dynamic>? params) {
    final sortedParams = params?.entries.toList()
      ?..sort((a, b) => a.key.compareTo(b.key));
    final paramsString = sortedParams?.map((e) => '${e.key}=${e.value}').join('&') ?? '';
    return '$endpoint?$paramsString';
  }

  T? get<T>(String endpoint, {Map<String, dynamic>? params}) {
    _cleanExpiredEntries();
    final key = _generateKey(endpoint, params);
    final entry = _cache[key];
    
    if (entry != null && !entry.isExpired(DateTime.now())) {
      return entry.data as T?;
    }
    
    return null;
  }

  void set<T>(
    String endpoint, 
    T data, {
    Map<String, dynamic>? params,
    Duration? cacheDuration,
    bool isRateLimited = false,
  }) {
    _cleanExpiredEntries();
    final key = _generateKey(endpoint, params);
    final duration = isRateLimited 
        ? _rateLimitCacheDuration 
        : (cacheDuration ?? _defaultCacheDuration);
    
    _cache[key] = CacheEntry(
      data: data,
      timestamp: DateTime.now(),
      duration: duration,
    );
  }

  void remove(String endpoint, {Map<String, dynamic>? params}) {
    final key = _generateKey(endpoint, params);
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  bool hasValidCache(String endpoint, {Map<String, dynamic>? params}) {
    _cleanExpiredEntries();
    final key = _generateKey(endpoint, params);
    final entry = _cache[key];
    return entry != null && !entry.isExpired(DateTime.now());
  }

  int get cacheSize => _cache.length;

  void setCacheDurationForEndpoint(
    String endpoint, 
    Duration duration, {
    Map<String, dynamic>? params
  }) {
    final key = _generateKey(endpoint, params);
    final entry = _cache[key];
    if (entry != null) {
      _cache[key] = CacheEntry(
        data: entry.data,
        timestamp: entry.timestamp,
        duration: duration,
      );
    }
  }
}

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;
  final Duration duration;

  CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool isExpired(DateTime now) {
    return now.difference(timestamp) > duration;
  }

  DateTime get expiresAt => timestamp.add(duration);
}
