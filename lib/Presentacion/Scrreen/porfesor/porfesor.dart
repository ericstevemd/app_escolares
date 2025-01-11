
import 'package:app_escolares/Presentacion/Scrreen/porfesor/Ajustes.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/asistencias.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/Curso.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/subir_novedades.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/tarea.dart';
import 'package:app_escolares/config/map.materia_profesor.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Porfesor extends StatefulWidget {
final String nombre;
final String correo;
 final int profesorId;

  const Porfesor({super.key, 
  required this.nombre, 
  required this.correo,
  required this.profesorId, });

  @override
  State<Porfesor> createState() => _PorfesorState();
}
int _selectedIndex=0;
late Future<ProfesorYMateria> _profesorYMateria;
@override

 void initState() {
 initState();
_profesorYMateria = fetchProfesorYMateria as Future<ProfesorYMateria>;
  }

  
 Future<ProfesorYMateria> fetchProfesorYMateria( widget) async {
    final response = await http.get(Uri.parse('http://localhost:3002/profesor/${widget.profesorId}/materias'));

    if (response.statusCode == 200) {
      return ProfesorYMateria.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load materias');
    }
  }

  @override
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
      ),
    body: FutureBuilder<ProfesorYMateria>(
        future: _profesorYMateria,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.materias.isEmpty) {
            return const Center(child: Text('No hay materias asignadas.'));
          } else {
            final profesor = snapshot.data!;
            return ListView.builder(
              itemCount: profesor.materias.length,
              itemBuilder: (context, index) {
                final materia = profesor.materias[index];
                return ListTile(
                  title: Text(materia.nombreMateria),
                );
              },
            );
          }
        },
      ),
    );
  }
    
     
    
  }



