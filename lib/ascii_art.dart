import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:nocterm_test/ramp.dart';

/// 低密度のアスキー変換に使う文字ランプ。
const _asciiRamp0 = ' .:-=+*#%@';

/// 中密度のアスキー変換に使う文字ランプ。
const _asciiRamp1 = ' .,:-=;+*!?#%XW@\$';

/// 高密度のアスキー変換に使う文字ランプ。
const _asciiRamp2 =
    ' .\'`^",:;Il!i><~+_-?][}{1)(|\/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@\$';

/// 画像ファイルをアスキーアート行データへ変換する。
List<String> asciiArtFromFileName(
  String fileName, {
  Ramp ramp = Ramp.ramp1,
  required int quantizeWidth,
  required int quantizeHeight,
}) {
  final file = File(fileName);
  final bytes = file.readAsBytesSync();
  final decoded = img.decodeImage(bytes);

  if (decoded == null) {
    return const ['Failed to decode image'];
  }

  final asciiRamp = _getRampLetters(ramp);
  final resized = img.copyResize(
    decoded,
    width: (decoded.width ~/ quantizeWidth).clamp(1, decoded.width),
    height: (decoded.height ~/ quantizeHeight).clamp(1, decoded.height),
    interpolation: img.Interpolation.average,
  );

  final lines = <String>[];
  for (var y = 0; y < resized.height; y++) {
    final buffer = StringBuffer();
    for (var x = 0; x < resized.width; x++) {
      final pixel = resized.getPixel(x, y);
      final gray = (pixel.r * 0.299 + pixel.g * 0.587 + pixel.b * 0.114)
          .round();
      final index = (gray * (asciiRamp.length - 1) / 255)
          .clamp(0, asciiRamp.length - 1)
          .toInt();
      buffer.write(asciiRamp[index]);
    }
    lines.add(buffer.toString());
  }

  return lines;
}

String _getRampLetters(Ramp ramp) {
  return switch (ramp) {
    Ramp.ramp0 => _asciiRamp0,
    Ramp.ramp1 => _asciiRamp1,
    Ramp.ramp2 => _asciiRamp2,
  };
}
