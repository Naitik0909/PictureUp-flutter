import 'dart:collection';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class BucketFill {
  List<Offset> _points = <Offset>[];
  Uint32List words;
  static int width;
  Color oldColor, pixel;
  int imageWidth;
  int imageHeight;

  Future<List> capturePng(GlobalKey key, Offset offset) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final rgbaImageData =
    await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    imageHeight = image.height;
    imageWidth = image.width;
    words = Uint32List.view(rgbaImageData.buffer, rgbaImageData.offsetInBytes,
        rgbaImageData.lengthInBytes ~/ Uint32List.bytesPerElement);
    oldColor = _getColor(words, offset.dx, offset.dy);
    return _floodfill(oldColor, offset.dx, offset.dy);
  }

  Color _getColor(Uint32List words, double x1, double y1) {
    int x = x1.toInt();
    int y = y1.toInt();
    var offset = x + y * imageWidth;
    return Color(words[offset]);
  }

// Queue based approach.
  List<Offset> _floodfill(Color oldColor, double x, double y) {
    Queue<Offset> queue = new Queue();
    Offset temp;
    queue.add(Offset(x, y));
    _points = List.from(_points)..add(queue.first);
    while (queue.isNotEmpty) {
      temp = queue.first;
      queue.removeFirst();
      if (_shouldFillColor(temp.dx + 2, temp.dy)) {
        queue.add(Offset(temp.dx + 2, temp.dy));
        _points.add(Offset(temp.dx + 2, temp.dy));
      }
      if (_shouldFillColor(temp.dx - 2, temp.dy)) {
        queue.add(Offset(temp.dx - 2, temp.dy));
        _points.add(Offset(temp.dx - 2, temp.dy));
      }
      if (_shouldFillColor(temp.dx, temp.dy + 2)) {
        queue.add(Offset(temp.dx, temp.dy + 2));
        _points.add(Offset(temp.dx, temp.dy + 2));
      }
      if (_shouldFillColor(temp.dx, temp.dy - 2)) {
        queue.add(Offset(temp.dx, temp.dy - 2));
        _points.add(Offset(temp.dx, temp.dy - 2));
      }
    }
    _points.add(null);
    return _points;
  }

  bool _shouldFillColor(double x, double y) {
    return (x >= 0 &&
        x < imageWidth &&
        y >= 0 &&
        y < imageHeight &&
        !_points.contains(Offset(x, y)))
        ? _getColor(words, x, y) == oldColor
        : false;
  }
}