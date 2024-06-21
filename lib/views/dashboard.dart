// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:alpha_miles/views/about_screen.dart';
import 'package:alpha_miles/views/add_rider_screen.dart';
import 'package:alpha_miles/views/dashboard_screen.dart';
import 'package:alpha_miles/views/login_screen.dart';
import 'package:alpha_miles/views/riders_screen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedNavItem = 'Dashboard';

  List<Widget> screensList = [
    DashboardScreen(),
    AddRiderScreen(),
    RidersScreen(),
    AboutScreen(),
  ];

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              width: screenWidth * 0.2,
              height: screenHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/logo/logo_1.png',
                        width: screenWidth * 0.15,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      NavItem(
                        label: 'Dashboard',
                        isSelected: selectedNavItem == 'Dashboard',
                        icon: Icons.dashboard,
                        onTap: () {
                          pageController.animateToPage(0,
                              duration: Duration(microseconds: 10),
                              curve: Curves.ease);
                          setState(() {
                            selectedNavItem = 'Dashboard';
                          });
                        },
                      ),
                      NavItem(
                        label: 'Add Rider',
                        isSelected: selectedNavItem == 'Add Rider',
                        icon: Icons.person_add_sharp,
                        onTap: () {
                          pageController.animateToPage(1,
                              duration: Duration(microseconds: 10),
                              curve: Curves.ease);
                          setState(() {
                            selectedNavItem = 'Add Rider';
                          });
                        },
                      ),
                      NavItem(
                        label: 'Riders',
                        isSelected: selectedNavItem == 'Riders',
                        icon: Icons.people,
                        onTap: () {
                          pageController.animateToPage(2,
                              duration: Duration(microseconds: 10),
                              curve: Curves.ease);
                          setState(() {
                            selectedNavItem = 'Riders';
                          });
                        },
                      ),
                      NavItem(
                        label: 'About',
                        isSelected: selectedNavItem == 'About',
                        icon: Icons.info_rounded,
                        onTap: () {
                          pageController.animateToPage(3,
                              duration: Duration(microseconds: 10),
                              curve: Curves.ease);
                          setState(() {
                            selectedNavItem = 'About';
                          });
                        },
                      ),
                    ],
                  ),
                  NavItem(
                      label: 'Logout',
                      isSelected: false,
                      icon: Icons.logout,
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninScreen()));
                      }),
                ],
              ),
            ),
            Container(
              width: 2,
              height: screenHeight,
              color: Colors.black12,
              margin: EdgeInsets.symmetric(horizontal: 20),
            ),
            SizedBox(
              width: screenWidth * 0.73,
              child: PageView(
                controller: pageController,
                children: screensList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  const NavItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.red : Colors.black,
            ),
            SizedBox(
              width: 10,
            ),
            Text(label),
          ],
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10))
            : null,
      ),
    );
  }
}
