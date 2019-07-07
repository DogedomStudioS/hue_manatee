import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Center(
          child: Column(
            mainAxisAlignment:  MainAxisAlignment.center,
            children: <Widget>[
              Text('Hue Manatee'),
              Text('Copyright 2019 Dogedom StudioS')
            ],
          ),
        ) 
      )
    );
  }
}