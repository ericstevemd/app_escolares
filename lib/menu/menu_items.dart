import 'package:flutter/material.dart';

class MenuItems {
final String title;
final String SubTitle;
final String link;
final IconData icon;

const MenuItems({
  required this.title ,
   required this.SubTitle, 
   required this.link,
   required this.icon });
}

const appMenuItems=<MenuItems>[
  MenuItems(
    title: 'Registro',
    SubTitle:'registra estudiantes ',
    link: '/registro', 
    icon: Icons.record_voice_over),
    MenuItems(
    title: 'Prefil estudiantes',
    SubTitle:'visualizar el estudiantes ',
    link: '/prefil-estudiantes', 
    icon: Icons.photo_camera_front_sharp),
 MenuItems(
    title: 'Prefil Docentes',
    SubTitle:'visualizar el Docentes  ',
    link: '/prefil-docentes', 
    icon: Icons.photo_camera_front_sharp),

 MenuItems(
    title: 'Avisos Generales',
    SubTitle:'visualizar a aviso',
    link: '/avisos-generales', 
    icon: Icons.notifications_active_outlined),
];



