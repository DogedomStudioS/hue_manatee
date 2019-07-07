import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'image_processing/pixel_utils.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:async';
import 'dart:core';

class ColorPicker extends StatefulWidget {
  final Color color;

  ColorPicker({Key key, this.color}) : super(key: key);
  State<StatefulWidget> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  File _imageFile;
  ui.Image _image;
  PixelUtils _pixelUtils;
  GlobalKey<_ColorPreviewState> _colorPreviewStateKey = GlobalKey<_ColorPreviewState>();
  GlobalKey<State<PhotoView>> _photoViewStateKey = GlobalKey<State<PhotoView>>();
  PhotoViewControllerBase controller = PhotoViewController()
      ..scale = 1.0;

  Future _chooseImage() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    var imageData = await ui.instantiateImageCodec(await imageFile.readAsBytes());
    var frame = await imageData.getNextFrame();
    _image = frame.image;
    _pixelUtils = PixelUtils(frame.image);
    setState(() {
      _imageFile = imageFile;
    });
  }

  void onControllerState(PhotoViewControllerValue value) {}

  _handleTouchStart(PointerUpEvent event) {
    _handleTouch(event.position);
  }

  _handleTouchMove(PointerMoveEvent event) {
    _handleTouch(event.position);
  }

  _handleTouch(Offset position) {
    PhotoView photoView = _photoViewStateKey.currentWidget;
    RenderBox widgetRenderBox = _photoViewStateKey.currentContext.findRenderObject();
    Size widgetSize = widgetRenderBox.size;
    var scale = controller.scale;
    if (scale == null) {
      scale = 1.0 / (_image.height > widgetSize.height ? _image.height / widgetSize.height : widgetSize.height / _image.height);
    }
    var offset = controller.position;
    var scaleFactor = 1 / scale;
    var minX = (_image.width * 0.5) - (offset.dx * scaleFactor) - (widgetSize.width * 0.5 * scaleFactor);
    var minY = (_image.height * 0.5) - (offset.dy * scaleFactor) - (widgetSize.height * 0.5 * scaleFactor);
    var x = minX + (position.dx * scaleFactor);
    var y = minY + (position.dy * scaleFactor);
    x = x.clamp(1.0, _image.width.toDouble() - 2.0);
    y = y.clamp(1.0, _image.height.toDouble() - 2.0);
    _pixelUtils.getColor(x.toInt(), y.toInt()).then((color) {
      _colorPreviewStateKey.currentState.updateColor(color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Stack(
        children: <Widget>[
          Listener(
            onPointerUp: _handleTouchStart,
            onPointerMove: _handleTouchMove,
            child: Center(
              child: _imageFile == null
              ? Text('')
              : PhotoView(
                  key: _photoViewStateKey,
                  imageProvider: FileImage(_imageFile),
                  controller: controller,
                  initialScale: PhotoViewComputedScale.covered,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: 8.0,
                ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: _ColorPreview(color: Colors.black, colorPreviewStateKey: _colorPreviewStateKey,),
                ),
                Flexible(
                  flex: 1,
                  child: FloatingActionButton(
                    backgroundColor: Colors.blue,
                    onPressed: _chooseImage,
                    child: Icon(Icons.image),
                  )
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}

class _ColorPreview extends StatefulWidget {
  final Color color;
  final GlobalKey<_ColorPreviewState> colorPreviewStateKey;

  _ColorPreview({Key key, this.color, this.colorPreviewStateKey}) : super(key: colorPreviewStateKey);

  @override
  State<StatefulWidget> createState() => _ColorPreviewState();
}

class _ColorPreviewState extends State<_ColorPreview> {
  Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  void updateColor(Color newColor) {
    setState(() {
      this.color = newColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minWidth: 64,
        minHeight: 64,
        maxWidth: 64,
        maxHeight: 64
      ),
      color: color
    );
  }
}
