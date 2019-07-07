import 'package:flutter/material.dart';
import 'models/palette.dart';

class PaletteView extends StatefulWidget {
  final Palette palette;

  PaletteView(this.palette);

  @override
  State<StatefulWidget> createState() => _PaletteViewState(this.palette);
}

class _PaletteViewState extends State<PaletteView> {
  Palette palette;

  _PaletteViewState(this.palette);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Palette"),
        ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
      )
    );
  }
}