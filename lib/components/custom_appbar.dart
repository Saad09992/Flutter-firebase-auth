import 'package:firebase_auth_app/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          icon: Obx(() {
            // Dynamically change the icon based on the current theme
            return Icon(
              themeController.currentTheme == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            );
          }),
          onPressed: themeController.toggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
