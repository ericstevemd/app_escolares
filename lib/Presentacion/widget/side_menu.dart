import 'package:app_escolares/menu/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class SideMenu extends StatefulWidget {
  final String userCedula;

  
  const SideMenu({super.key, required this.userCedula});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int navDrawerIndex = 1;
late String userCedula;
late String userEmail;

  @override
  void initState() {
    super.initState();
  userCedula =widget.userCedula;
  }

 
  @override
Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: 
      navDrawerIndex,onDestinationSelected:(vaule){
        setState(() {
          navDrawerIndex= vaule;
        });

        final menuIten = appMenuItems[vaule];
        context.push(menuIten.link);
      }, children: [
UserAccountsDrawerHeader(accountName:Text(userCedula , style:const TextStyle(color: Colors.black ),), 
currentAccountPicture: const CircleAvatar(backgroundImage:NetworkImage('https://cdn-icons-png.flaticon.com/512/4792/4792929.png'),),
accountEmail: const Text("Administrador",style:TextStyle(color: Colors.black),), decoration:const BoxDecoration(color:Colors.tealAccent),),

...appMenuItems

.map((item)=>  NavigationDrawerDestination(
  icon: Icon(item.icon), label: Text(item.title),)).toList()
],);}
}





