import 'package:flutter/material.dart';
import 'package:stockappflutter/main.dart';
import 'package:stockappflutter/utilities/auth_utils.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [Colors.blue, Colors.purple];
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            const SizedBox(height: 50),
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/WWlogo.png'), // Add your logo
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text(
                "Dashboard",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                navigatorKey.currentState!
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.white,
              ),
              title: const Text(
                "Favorites",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/favorites');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.newspaper,
                color: Colors.white,
              ),
              title: const Text(
                "News Room",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                print("News Room was pressed");
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              title: const Text(
                "Account",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                navigatorKey.currentState!.pushNamed('/account_page');
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              title: const Text(
                "Signout",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => signUserOut(),
            ),
            const Spacer(),
          ]),
        ),
      ),
    );
  }
}
