// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const CustomBottomNavBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: (index) {
//         onTap(index);
//         switch (index) {
//           case 0:
//             Get.toNamed('/home');
//             break;
//           case 1:
//             Get.toNamed('/map');
//             break;
//           case 2:
//             Get.toNamed('/messages');
//             break;
//         }
//       },
//       selectedItemColor: const Color(0xFF00ADB5),
//       unselectedItemColor: Colors.grey,
//       backgroundColor: const Color.fromARGB(255, 238, 238, 238),
//       items: const <BottomNavigationBarItem>[
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_filled),
//           label: 'Inicio'),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.map),
//           label: 'Mapa',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Perfil',
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:promo_san_juan/screens/home/home_screen.dart';
import 'package:promo_san_juan/screens/maps/map_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomeScreen(),
    const MapScreen(),
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
