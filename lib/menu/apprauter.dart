import 'package:app_escolares/Presentacion/Scrreen/administrador/Avisos_generales.dart';
import 'package:app_escolares/Presentacion/Scrreen/administrador/Prefil_docentes.dart';
import 'package:app_escolares/Presentacion/Scrreen/administrador/Prefil_estudiantes.dart';
import 'package:app_escolares/Presentacion/Scrreen/administrador/administrador.dart';
import 'package:app_escolares/Presentacion/Scrreen/administrador/registro.dart';
import 'package:app_escolares/Presentacion/Scrreen/estudiantes/estudiantes.dart';
import 'package:app_escolares/Presentacion/Scrreen/login/loginScreen.dart';
import 'package:app_escolares/Presentacion/Scrreen/repesentante/representante.dart';
import 'package:go_router/go_router.dart';
dynamic Login;


final appRouter=GoRouter(

  routes:[
    GoRoute(path: '/',
    builder: (context, state) => const Loginscreen(),
    ),
     GoRoute(path: '/Administrador',
    builder: (context, state) => const Administrador(userCedula: 'userCedula'),
    ),
    
 GoRoute(path: '/Estudiantes',
    builder: (context, state) => const Estudiantes(),
    ),
    

     GoRoute(path: '/Representante',
    builder: (context, state) => const Representante(),
    ),
    




    GoRoute(path: '/registro',
    builder: (context, state) => const Registro(),
    ),
      GoRoute(path: '/prefil-estudiantes',
    builder: (context, state) => const PrefilEstudiantes(),
    ),
    
      GoRoute(path: '/prefil-docentes',
    builder: (context, state) => const PrefilDocentes(),
    ),
      GoRoute(path: '/avisos-generales',
    builder: (context, state) => const AvisosGenerales(),
    ),
  ]
);