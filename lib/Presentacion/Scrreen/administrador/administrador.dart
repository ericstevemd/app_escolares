import 'package:app_escolares/Presentacion/widget/side_menu.dart';
import 'package:flutter/material.dart';

class Administrador extends StatefulWidget {
   final String userCedula;

  const Administrador({
    super.key,
   required this.userCedula});

  @override
  State<Administrador> createState() => _AdministradorState();
}

class _AdministradorState extends State<Administrador> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home-administrador "),
        
      ),
      drawer:  SideMenu(userCedula: widget.userCedula),
    );
  }
}