import 'package:ecommerce_app/view/cart.dart';
import 'package:ecommerce_app/view/home.dart';
import 'package:ecommerce_app/view/login.dart';
import 'package:ecommerce_app/view/order_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  final String username;
  final String password;
  const DrawerWidget(
      {super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    Future<void> logout() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLoggedIn", false);
      prefs.remove("username");
      prefs.remove("password");
    }

    return Drawer(
      backgroundColor: Color(0xFFB0D9B1),
      child: Builder(
        builder: (drawerContext) => ListView(
          children: [
            AppBar(
              backgroundColor: const Color(0xFFB0D9B1),
              title: const Text(
                'My Dashboard',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(Icons.home),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomePage(
                    username: username,
                    password: password,
                  ),
                ));
              },
            ),
            ListTile(
              title: const Text(
                'My Cart',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(Icons.shopping_cart),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CartPage(),
                ));
              },
            ),
            ListTile(
              title: const Text(
                'My Order Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(Icons.card_giftcard_sharp),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const OrderDetailPage(),
                ));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: const Icon(
                Icons.power_settings_new,
                color: Color(0xFFB31312),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black87,
              ),
              onTap: () async {
                await logout();

                // Navigate to the LoginPage
                Navigator.pushReplacement(
                  drawerContext,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
