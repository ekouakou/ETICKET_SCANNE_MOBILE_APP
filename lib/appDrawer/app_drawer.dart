import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu_config.dart';
import '../utils/theme_provider.dart';
import 'menu_item.dart';
import 'drawer_item.dart';
import '../utils/colors.dart';

class AppDrawer extends StatelessWidget {
  final String? userEmail;
  final Function(BuildContext)? signOut;
  final String? userId;
  final Future<int> Function(String)? getCombinedTotalRecords;
  final String? userName;  // Paramètre pour le nom de l'utilisateur
  final String? avatarImage;  // Paramètre pour l'image de l'avatar

  const AppDrawer({
    Key? key,
    this.userEmail,
    this.signOut,
    this.userId,
    this.getCombinedTotalRecords,
    this.userName,  // Initialisation du nom
    this.avatarImage,  // Initialisation de l'image
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getGradient(context),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(context),
            _buildMenuItems(context),
          ],
        ),
      ),
    );
  }


  Widget _buildDrawerHeader(BuildContext context) {
    return Container(
      /*decoration: BoxDecoration(
        gradient: AppColors.getGradient(context),
      ),*/
      padding: EdgeInsets.only(
        top: 100.0,   // Padding en haut
        bottom: 30.0, // Padding en bas
        left: 20.0,   // Padding à gauche
        right: 20.0,  // Padding à droite
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: avatarImage != null
                ? AssetImage(avatarImage!)  // Utilisation du paramètre avatarImage
                : AssetImage('assets/images/logo_1.png'),  // Image par défaut
          ),
          SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName ?? 'Guinée Ticket',  // Utilisation du paramètre userName
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              if (userEmail != null)
                Text(
                  userEmail!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return FutureBuilder<List<MenuItem>>(
      future: loadMenuItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: snapshot.data!.map((item) => _buildMenuItem(context, item)).toList(),
        );
      },
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    if (item.children != null && item.children!.isNotEmpty) {
      return ExpansionTile(
        leading: Icon(item.icon),
        title: Text(item.title),
        children: item.children!
            .map((child) => DrawerItem(
          icon: child.icon,
          text: child.title,
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(child.route ?? '/');
          },
        ))
            .toList(),
      );
    }

    if (item.id == 'theme_toggle') {
      return DrawerItem(
        icon: item.icon,
        text: context.watch<ThemeProvider>().isDarkMode ? 'Mode clair' : 'Mode sombre',
        onTap: () => context.read<ThemeProvider>().toggleTheme(),
      );
    }

    if (item.id == 'logout' && signOut != null) {
      return DrawerItem(
        icon: item.icon,
        text: item.title,
        onTap: () => signOut!(context),
      );
    }

    if (item.id == 'liste_inscrit' && getCombinedTotalRecords != null && userId != null) {
      return FutureBuilder<int>(
        future: getCombinedTotalRecords!(userId!),
        builder: (context, snapshot) {
          return DrawerItem(
            icon: item.icon,
            text: item.title,
            trailing: CircleAvatar(
              radius: 10,
              child: Text('${snapshot.data ?? 0}', style: TextStyle(fontSize: 12)),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(item.route ?? '/');
            },
          );
        },
      );
    }

    return DrawerItem(
      icon: item.icon,
      text: item.title,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(item.route ?? '/');
      },
    );
  }
}
