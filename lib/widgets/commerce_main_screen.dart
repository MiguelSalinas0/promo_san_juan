// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:promo_san_juan/screens/commerce/home_commerce_screen.dart';
import 'package:promo_san_juan/screens/commerce/profile_commerce_screen.dart';

class CommerceMainScreen extends StatefulWidget {
  const CommerceMainScreen({super.key});

  @override
  _CommerceMainScreenState createState() => _CommerceMainScreenState();
}

class _CommerceMainScreenState extends State<CommerceMainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const CommerceHome(),
    const ProfileCommerceScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF00ADB5),
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: 'Promociones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
