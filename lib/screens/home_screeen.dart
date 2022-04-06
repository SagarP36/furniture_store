import 'package:flutter/material.dart';
import 'package:furniture_store/controllers/cart_controller.dart';
import 'package:furniture_store/screens/MainScreen.dart';
import 'package:furniture_store/screens/cart_screen.dart';
import 'package:furniture_store/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:icon_badge/icon_badge.dart';

final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final cartController = Get.find<CartController>();
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.5),
        onTap: (index) {
          _tabController.animateTo(index);
          setState(() {});
        },
        currentIndex: _tabController.index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Obx(
              () => IconBadge(
                icon: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                itemCount: cartController.cart.value.length,
                badgeColor: Colors.red,
                itemColor: Colors.green,
                hideZero: true,
              ),
            ),
            label: 'Cart',
            backgroundColor: Colors.white,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              MainScreen(),
              CartScreen(),
              ProfileScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
