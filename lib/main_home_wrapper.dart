import 'package:flutter/material.dart';
import 'package:flutter_application_2/histroy.dart';
import 'package:flutter_application_2/pricelens.dart';
import 'scan.dart';
import 'profile.dart';

class MainWrapper extends StatefulWidget {
  final VoidCallback onLogout;

  const MainWrapper({super.key, required this.onLogout});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int index = 0;

  final screens = [
    const PriceLensHomeScreen(),
    const PriceLensHistoryScreen(),
    const PremiumScanScreen(),
    ProfileScreen(), // remove const if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
