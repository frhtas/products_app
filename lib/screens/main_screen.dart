import 'package:flutter/material.dart';
import 'package:products_app/screens/home_screen.dart';
import 'package:products_app/screens/my_cart_screen.dart';
import 'package:products_app/screens/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const MyCartScreen(),
    const SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: screens.elementAt(selectedIndex)),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 4,
          labelTextStyle: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.selected)) {
                return const TextStyle(fontWeight: FontWeight.w500);
              }
              return const TextStyle(fontWeight: FontWeight.w400);
            },
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_rounded),
              label: "My Cart",
            ),
            NavigationDestination(
              icon: Icon(Icons.search_rounded),
              label: "Search",
            )
          ],
        ),
      ),
    );
  }
}
