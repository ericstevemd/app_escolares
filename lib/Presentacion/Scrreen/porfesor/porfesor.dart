
import 'package:app_escolares/Presentacion/Scrreen/porfesor/Ajustes.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/tarea.dart';
import 'package:flutter/material.dart';

class Porfesor extends StatefulWidget {
final String nombre;
final String correo;

  const Porfesor({super.key, 
  required this.nombre, 
  required this.correo});

  @override
  State<Porfesor> createState() => _PorfesorState();
}
int _selectedIndex=0;



class _PorfesorState extends State<Porfesor> {
  
  @override



  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profesor'),
      
      ),
      drawer: Drawer( child: Container(
        padding: const EdgeInsets.all(24),
        child:     
       Wrap(children: [
   UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://us.123rf.com/450wm/tuktukdesign/tuktukdesign1606/tuktukdesign160600119/59070200-icono-de-usuario-hombre-perfil-hombre-de-negocios-avatar-icono-persona-en-la-ilustraci%C3%B3n.jpg'),
              ),
              accountName: Text(widget.nombre),
              accountEmail:Text(widget.correo),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
      const Divider(color: Colors.black54,),
        ListTile(
          leading: const Icon(Icons.home_outlined ,color: Colors.yellow,) ,
          title: const Text('Curso'),
          selected: _selectedIndex==0,
          onTap: (){

    
          Navigator.pop(context);
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Curso()));
                 }
        ),

         ListTile(
          leading: const Icon(Icons.account_box_sharp,color:Colors.blue,),
          title: const Text('subir novedades'),
           selected: _selectedIndex==1,
         onTap: () {
         Navigator.pop(context);
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SubirNovedades()));
        } ),
         ListTile(
          leading: const Icon(Icons.folder ,color: Colors.yellow,),
          title: const Text('subir tarea'),
           selected: _selectedIndex==2,
       onTap: (){
            Navigator.pop(context);
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Tarea()));
                 }
        ),
        //  ListTile(
        //   leading: const Icon(Icons.shopping_cart_outlined ,color: Colors.green,),
        //   title: const Text('carrito'),
        //   onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Carrito())),
        // ),
         ListTile(
          leading: const Icon(Icons.account_box_rounded,color: Colors.blueAccent,),
          title: const Text('asistencias'),
           selected: _selectedIndex==3,
           onTap: (){
          Navigator.pop(context);
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Asistencias()));
                 },
        ),
         ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Ajustes'),
           selected: _selectedIndex==4,
           onTap: (){   
          Navigator.pop(context);
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Ajustes()));
                 }
        ),
        const Divider(color: Colors.black54,),
         ListTile(
          leading: const Icon(Icons.exit_to_app),
           selected: _selectedIndex==5,
          title: const Text('cerrar session '),
        onTap: (){ }
        ),
      ],)
      )
      ));
    
     
    
  }
}


