import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:async';

class PixelUtils {
  ui.Image _image;
  ByteData _imageData;

  PixelUtils(ui.Image image) {
    _image = image;
  }

  Future<Color> getColor(int x, int y) async {
    if (_imageData == null) {
      _imageData = await _image.toByteData(format: ui.ImageByteFormat.rawRgba);
    }
    Iterable<Color> _colorData = _getImagePixels(_imageData, _image.width, _image.height, Offset(x - 1.0, y - 1.0) & Size(3, 3));
    int pixelIndex = 8;
    return _colorData.elementAt(pixelIndex);
  }

  Iterable<Color> _getImagePixels(ByteData pixels, int width, int height, Rect region) sync* {
      final int rowStride = width * 4;
      int rowStart;
      int rowEnd;
      int colStart;
      int colEnd;
      if (region != null) {
        rowStart = region.top.floor();
        rowEnd = region.bottom.floor();
        colStart = region.left.floor();
        colEnd = region.right.floor();
        assert(rowStart >= 0);
        assert(rowEnd <= height);
        assert(colStart >= 0);
        assert(colEnd <= width);
      } else {
        rowStart = 0;
        rowEnd = height;
        colStart = 0;
        colEnd = width;
      }
      int byteCount = 0;
      for (int row = rowStart; row < rowEnd; ++row) {
        for (int col = colStart; col < colEnd; ++col) {
          final int position = row * rowStride + col * 4;
          // Convert from RGBA to ARGB.
          final int pixel = pixels.getUint32(position);
          final Color result = Color((pixel << 24) | (pixel >> 8));
          byteCount += 4;
          yield result;
        }
      }
      assert(byteCount == ((rowEnd - rowStart) * (colEnd - colStart) * 4));
  }
}