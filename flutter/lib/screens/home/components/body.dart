import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/screens/home/subscreens/home_screen_view.dart';
import 'package:food_toxicity_scanner/screens/home/subscreens/scan_screen.dart';
import 'package:food_toxicity_scanner/screens/home/subscreens/search_screen.dart';

const _kPages = <String, IconData>{
  'Search': Icons.search,
  'Home': Icons.home,
  'Scan': Icons.camera_alt,
};

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConvexBottomBar();
  }
}

class ConvexBottomBar extends StatefulWidget {
  const ConvexBottomBar({Key key}) : super(key: key);

  @override
  _ConvexBottomBarState createState() => _ConvexBottomBarState();
}

class _ConvexBottomBarState extends State<ConvexBottomBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    SearchScreen(),
                    HomeScreenView(),
                    ScanScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.react,
          backgroundColor: Theme.of(context).primaryColor,
          items: <TabItem>[
            for (final entry in _kPages.entries)TabItem(icon: entry.value, title: entry.key),
          ],
          onTap: (i) => null,
        ),
      ),
    );
  }
}