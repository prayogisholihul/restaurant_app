import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restaurant_app/screen/favorite_screen.dart';
import 'package:restaurant_app/screen/main_screen.dart';
import 'package:restaurant_app/screen/search_screen.dart';

import '../service/notification_helper.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MainScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> requestPermissions() async {
    final List<Permission> permissions = [
      Permission.notification,
      Permission.scheduleExactAlarm
    ];
    await permissions.request();
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
    _notificationHelper.configureSelectNotificationSubject();
    _notificationHelper.configureDidReceiveLocalNotificationSubject(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
    super.dispose();
  }
}
