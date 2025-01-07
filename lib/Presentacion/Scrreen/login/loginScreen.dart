import 'dart:convert';
import 'package:app_escolares/Presentacion/Scrreen/administrador/administrador.dart';
import 'package:app_escolares/Presentacion/Scrreen/estudiantes/estudiantes.dart';
import 'package:app_escolares/Presentacion/Scrreen/porfesor/porfesor.dart';
import 'package:app_escolares/Presentacion/Scrreen/repesentante/representante.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import '../../../config/map.login.dart';
class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}
class _LoginscreenState extends State<Loginscreen> {
  
  final _cedulaController =TextEditingController();
  final _passwordControler=TextEditingController();
  bool _isLoading = false;




  Future<void> _login()async{
 final cedula = _cedulaController.text.trim(); // Elimina espacios extra
 final password = _passwordControler.text.trim(); // Elimina espacios extra
_isLoading;

if(cedula.isEmpty || password.isEmpty){
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content:Text('La cédula o la contraseña no pueden estar vacíos.')));
  return;
}

  final String url ='http://192.168.100.53:3002/usuario/login';

  setState(() {
    _isLoading=true;
  });

  try {
    // Realiza la petición POST
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'cedula': cedula, 'password': password}),
    );

    // Maneja las respuestas según el código de estado
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

 if (data == null || data is! Map) {
        throw Exception('La respuesta de la API no es válida.');
      }

      final token=data['token'];

      if (token != null) {
        // Guarda el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token',token);
        final userType=data['userType'];
        if(token  !=null && userType!=null){
           final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        }

       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicio de sesión exitoso.')),
       );

if(userType== 'ADMIN'){
Navigator.of (context).push(
  MaterialPageRoute(builder: (context)=> Administrador( userCedula: cedula))
);

}else if (userType== 'PROFESOR'){

  Navigator.of (context).push(
  MaterialPageRoute(builder: (context)=> const Porfesor ())
);

}
else if(userType=='REPRESENTANTE'){
  Navigator.of (context).push(
  MaterialPageRoute(builder: (context)=> const Representante ())
);


}else if (userType == 'ESTUDIANTE'){
  Navigator.of (context).push(
  MaterialPageRoute(builder: (context)=> const Estudiantes ())  );
}


        // Redirige al usuario a la siguiente pantalla
     /*  Navigator.of(context).push(
        MaterialPageRoute(builder: (context)=> const Home())
      ); */
    
      } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('No se recibio un Token')));
      }
    } else if (response.statusCode == 401) {
      print('Credenciales incorrectas.');
    } else {
      print('Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text(e.toString())),);
    }finally{
      setState(() {
        _isLoading=false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width =MediaQuery.of(context).size.width;
    return Scaffold( 
      backgroundColor: Colors.white,
          body: SingleChildScrollView(
            reverse: true,
            child: Wrap(
                    children: [Container(
            
            height:400,
            child: Stack(
              children: [
                Positioned(
                  top:-40,
                  height: 400,
                  width: width +20 ,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(image:AssetImage('assets/images/background-3.png'),fit: BoxFit.fill)
                  
                  ),
                ),),
            
             Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logoyasuni.png'),
                            fit: BoxFit.contain, // Mantiene las proporciones
                          ),
                        ),
                      ),
                    ),
                  
                
              
            // Positioned(
            //   width:300,
             
            //   child: Container(
            //   decoration:  const BoxDecoration(image:DecorationImage(  image:AssetImage('assets/images/logoyasuni.png'),)) ),
            // )
                
              ],
            ),
                    ),
            Padding(padding: const EdgeInsets.all(16.0),
            child: Column(children: [           
               const Text("LOGIN ",style: TextStyle(color: Colors.tealAccent,fontWeight: FontWeight.bold,fontSize:30 ),),
              TextField(controller: _cedulaController, decoration: const InputDecoration(labelText: 'cedula '),keyboardType: TextInputType.text,),
              TextField(controller: _passwordControler ,decoration: const InputDecoration(labelText: 'Password'),obscureText: true,),
                const SizedBox(height:16 ),
                _isLoading
                ?const CircularProgressIndicator()
                
                :ElevatedButton(             
                  onPressed: _login,
                  
                  style: ElevatedButton.styleFrom(backgroundColor:Colors.tealAccent),
                  child: const Text('Iniciar Sesión' ,style: TextStyle(color:Colors.black),),    
                ),
                
            
            
                 ]),),
                    ],
                  ),
          ),
      
    );
  }
}




