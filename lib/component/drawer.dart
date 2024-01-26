import 'package:flutter/material.dart';
import 'package:socialmedia/component/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onTapProfiles;
  final void Function()? onTapLogout;
  MyDrawer({super.key, required this.onTapProfiles, required this.onTapLogout});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // header
              DrawerHeader(
                  child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              )),

              // home list tile
              MyListTile(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),

              // profile list tile
              MyListTile(
                icon: Icons.person,
                text: "P R O F I L E S",
                onTap: onTapProfiles,
              ),
            ],
          ),

          // logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: MyListTile(
              icon: Icons.logout,
              text: "L O G O U T",
              onTap: onTapLogout,
            ),
          ),
        ],
      ),
    );
  }
}
