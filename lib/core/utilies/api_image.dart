import 'dart:convert';
import 'dart:typed_data';

/// Empty or malformed optional API images should behave like missing images.
Uint8List? decodeApiImage(dynamic value) {
  if (value is Uint8List) return value.isEmpty ? null : value;
  if (value is! String) return null;
  var encoded = value.trim();
  if (encoded.isEmpty) return null;
  if (encoded.startsWith('data:')) {
    final separator = encoded.indexOf(',');
    if (separator < 0) return null;
    encoded = encoded.substring(separator + 1);
  }
  encoded = encoded.replaceAll(RegExp(r'\s'), '');
  if (encoded.isEmpty) return null;
  try {
    final bytes = base64Decode(encoded);
    return bytes.isEmpty ? null : bytes;
  } on FormatException {
    return null;
  }
}
