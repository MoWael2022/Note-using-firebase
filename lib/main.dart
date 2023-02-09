import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled4/Home_screens/home.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_bloc.dart';
import 'package:untitled4/busniss_logic/auth_cubit/auth_cubit.dart';
import 'package:untitled4/busniss_logic/auth_cubit/auth_state.dart';
import 'Authentication/sign_in.dart';
import 'firebase_options.dart';
import 'package:sizer/sizer.dart';

bool? islogin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context)=> AuthBloc()),
       // BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: FirebaseAuth.instance.currentUser == null ? SignInPage() : HomePage(),
            );
          }
      ),
    );
  }
}
