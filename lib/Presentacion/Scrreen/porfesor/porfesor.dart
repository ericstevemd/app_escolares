
import 'package:app_escolares/Presentacion/Scrreen/porfesor/Ajustes.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/tarea.dart';
import 'package:flutter/material.dart';

class Porfesor extends StatefulWidget {
  const Porfesor({super.key});

  @override
  State<Porfesor> createState() => _PorfesorState();
}

class _PorfesorState extends State<Porfesor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profesor'),
      
      ),
      drawer: Drawer( child: Container(
        padding: const EdgeInsets.all(24),
        child:     
       Column(children: [
         const Divider(color: Colors.black54,),
        ListTile(
          leading: const Icon(Icons.home_outlined ,color: Colors.yellow,) ,
          title: const Text('Curso'),
          onTap: () => 
           Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Curso())),
        ),

         ListTile(
          leading: const Icon(Icons.account_box_sharp,color:Colors.blue,),
          title: const Text('subir novedades'),
         onTap: () {
         Navigator.pop(context);
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SubirNovedades()));
        } ),
         ListTile(
          leading: const Icon(Icons.folder ,color: Colors.yellow,),
          title: const Text('subir tarea'),
          onTap: ()=>  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Tarea())),
        ),
        //  ListTile(
        //   leading: const Icon(Icons.shopping_cart_outlined ,color: Colors.green,),
        //   title: const Text('carrito'),
        //   onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Carrito())),
        // ),
         ListTile(
          leading: const Icon(Icons.account_box_rounded,color: Colors.blueAccent,),
          title: const Text('asistencias'),
          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Asistencias())),
        ),
         ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Ajustes'),
          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const Ajustes ())),
        ),
        const Divider(color: Colors.black54,),
         ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('cerrar session '),
          onTap: (){},
        ),
      ],)
      )
      ));
    
     
    
  }
}