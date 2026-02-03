import 'package:flutter/material.dart';

import '../../../customer/presentation/pages/customer_view/customer_view.dart';
import '../../../route/presentation/pages/route.dart';
import '../widget/bottom_navi.dart';
import 'home_screen.dart';

class HomePage extends StatefulWidget {
  final int? index;
  const HomePage({super.key,this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const CustomerView(),
    const RoutePage()

  ];
  @override
  void initState() {
    _activeIndex=widget.index??0;
    // TODO: implement initState
    super.initState();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_activeIndex],
      bottomNavigationBar: BottomNavBar(
        activeIndex: _activeIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
