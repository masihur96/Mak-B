import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mak_b/bottom_navigation_bar/account_nav.dart';
import 'package:mak_b/bottom_navigation_bar/cart_page.dart';
import 'package:mak_b/bottom_navigation_bar/package_list.dart';
import 'package:mak_b/bottom_navigation_bar/product_page.dart';
import 'package:mak_b/variables/constants.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({Key? key}) : super(key: key);

  @override
  _HomeNavState createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> with TickerProviderStateMixin {
  TabController? _tabController;
  // String _pageTitle = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.green[50],
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: 'Product',
        labels: const ["Product", "Package", "Cart", "Account"],
        icons: const [
          FontAwesomeIcons.tshirt,
          FontAwesomeIcons.boxOpen,
          FontAwesomeIcons.cartPlus,
          FontAwesomeIcons.userCircle
        ],
        tabSize: 50,
        tabBarHeight: AppBar().preferredSize.height,
        textStyle: TextStyle(
          fontSize: size.width * .04,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        tabIconColor: Colors.grey.shade500,
        tabIconSize: 24.0,
        tabIconSelectedSize: 24.0,
        tabSelectedColor: Color(0xFF19B52B).withOpacity(0.1),
        tabIconSelectedColor: kPrimaryColor,
        tabBarColor: Colors.white,
        onTabItemSelected: (int value) {
          setState(() {
            _tabController!.index = value;
            // value == 0
            //     ? _pageTitle = 'Product'
            //     : value == 1
            //         ? _pageTitle = 'Package'
            //         :value == 2?_pageTitle = 'Cart'
            //         : _pageTitle = 'Account';
          });
        },
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[ProductPage(), PackageListPage(), CartPage(), AccountNav()],
      ),
    );
  }
}
