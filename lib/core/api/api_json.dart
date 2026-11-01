import 'dart:collection';

/// Reads API field names independently of their letter casing, including nested
/// objects, while keeping the original keys for iteration and serialization.
/// Only response objects use this view; outgoing request keys are unchanged.
class ApiJson {
  static Map<String, dynamic> object(Map value) =>
      value is _ApiJsonMap ? value : _ApiJsonMap(value);

  static dynamic decode(dynamic value) {
    if (value is Map) return object(value);
    if (value is List && value.any((item) => item is Map || item is List)) {
      return value.map(decode).toList();
    }
    return value;
  }
}

class _ApiJsonMap extends MapBase<String, dynamic> {
  _ApiJsonMap(Map source) {
    for (final entry in source.entries) {
      this[entry.key.toString()] = entry.value;
    }
  }

  final _values = <String, dynamic>{};
  final _keysByLowercase = <String, String>{};

  @override
  dynamic operator [](Object? key) =>
      _values[_keysByLowercase[key?.toString().toLowerCase()]];

  @override
  void operator []=(String key, dynamic value) {
    final normalized = key.toLowerCase();
    final existing = _keysByLowercase.putIfAbsent(normalized, () => key);
    _values[existing] = ApiJson.decode(value);
  }

  @override
  bool containsKey(Object? key) =>
      _keysByLowercase.containsKey(key?.toString().toLowerCase());

  @override
  Iterable<String> get keys => _values.keys;

  @override
  dynamic remove(Object? key) {
    final original = _keysByLowercase.remove(key?.toString().toLowerCase());
    return _values.remove(original);
  }

  @override
  void clear() {
    _values.clear();
    _keysByLowercase.clear();
  }
}
