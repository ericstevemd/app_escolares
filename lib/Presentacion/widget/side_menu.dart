import 'package:app_escolares/menu/menu_items.dart';
import 'package:flutter/material.dart';
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
      }, children: [
UserAccountsDrawerHeader(accountName:Text(userCedula), 
currentAccountPicture: const CircleAvatar(backgroundImage:NetworkImage('https://cdn-icons-png.flaticon.com/512/4792/4792929.png'),),
accountEmail: Text("correo@gmail.com"),),

...appMenuItems

.map((item)=>  NavigationDrawerDestination(
  icon: Icon(item.icon), label: Text(item.title))).toList()
],);}
}






//  Future<void> _fetchUserData() async {
//     // En lugar de usar el almacenamiento seguro, aquí puedes obtener el token de una manera diferente.
//     String? token = 'token'; // Reemplaza con la forma en la que obtienes el token (puede ser de un GlobalKey, SharedPreferences, etc.).

//     // ignore: unnecessary_null_comparison
//     if (token != null) {
//       final response = await http.get(
//         Uri.parse('http://192.168.100.53:3000/usuario/login'),
//         headers: {
//           'Authorization': 'Bearer $token', // Enviar el token en la cabecera
//         },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final data = json.decode(response.body);
//         setState(() {
//           ussercedula = data['user']['cedula'];
//           userEmail = data['user']['email'];
//         });
//       } else {
//         print('Error al obtener los datos del usuario');
//       }
//     } else {
//       print('Token no encontrado');
//     }
//   }