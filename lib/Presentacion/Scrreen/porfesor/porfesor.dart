import 'package:app_escolares/Presentacion/Scrreen/porfesor/curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
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
           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Curso())),
        ),

         ListTile(
          leading: const Icon(Icons.account_box_sharp,color:Colors.blue,),
          title: const Text('subir novedades'),
         onTap: () {
         Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const SubirNovedades()));
        } ),
         ListTile(
          leading: const Icon(Icons.folder ,color: Colors.yellow,),
          title: const Text('subir tarea'),
          onTap: (){},
        ),
         ListTile(
          leading: const Icon(Icons.shopping_cart_outlined ,color: Colors.green,),
          title: const Text('carrito'),
          onTap: (){},
        ),
         ListTile(
          leading: const Icon(Icons.account_box_rounded,color: Colors.blueAccent,),
          title: const Text('asistencias'),
          onTap: (){},
        ),
         ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Ajustes'),
          onTap: (){},
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