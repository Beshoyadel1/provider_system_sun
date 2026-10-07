import 'dart:typed_data';
import 'package:flutter/widgets.dart';

class MemoryImageWithFallback extends StatelessWidget {
  const MemoryImageWithFallback({
    super.key,
    required this.bytes,
    required this.fallback,
    this.width,
    this.height,
    this.fit,
  });

  final Uint8List? bytes;
  final Widget fallback;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (bytes == null || bytes!.isEmpty) return fallback;
    return Image.memory(
      bytes!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => fallback,
    );
  }
}
