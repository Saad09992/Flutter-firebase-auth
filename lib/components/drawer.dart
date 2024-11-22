import 'package:firebase_auth_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../utils/routes/routes_name.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();

    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                if (authController.isAuthenticated)
                  _buildDrawerItem(context, RoutesName.home, 'Home', Icons.home)
                else if (!authController.isAuthenticated)
                  _buildDrawerItem(
                      context, RoutesName.signup, 'Sign Up', Icons.person),

                // Only show Login if the user is not logged in
                if (!authController.isAuthenticated)
                  _buildDrawerItem(
                      context, RoutesName.signin, 'Sign In', Icons.info),
              ],
            ),
          ),
          if (authController.isAuthenticated)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  authController.signOut(context);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(
      BuildContext context, String route, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue), // Stylish icons for each route
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
