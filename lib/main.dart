import 'package:flutter/material.dart';
import 'settings.dart';
import 'color_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue Manatee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HueManatee(),
    );
  }
}

class HueManatee extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HueManateeState();
}

class _HueManateeState extends State<HueManatee> {
  PageController _pageController;
  int _page = 0;

  final List<Widget> _children = [
    ColorPicker(color: Colors.grey),
    SettingsPage()
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _children,
        onPageChanged: onPageChanged,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
     bottomNavigationBar: Theme(
        data: Theme.of(context),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.palette
              ),
              title: new Text('Colors')
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings
              ),
              title: new Text('Settings'),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      )
    );
  }
}
