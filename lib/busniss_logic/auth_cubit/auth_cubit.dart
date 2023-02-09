import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import 'package:untitled4/busniss_logic/auth_cubit/auth_state.dart';


class AuthCubit extends Cubit<AuthState>{
  AuthCubit():super(AuthInitial());

  UserCredential? user;
  void RegisterUser(
      String passwordController,
      String emailController,
      String confirmPassword,
      String userNameController,
      String phone) {


    emit(RegisterLoading());

      if (passwordController != confirmPassword) {
        emit(RegisterFailure(errorMsg: 'Password doesn\'t Match'));
      } else {
        FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController,
          password: passwordController,
        )
            .then((value) {
          user = value;
          // FirebaseFirestore.instance.collection("users").add({
          //   "username": userNameController,
          //   "Email": emailController,
          //   "Phone": phone,
          //   "userid": FirebaseAuth.instance.currentUser?.uid,
          // });
          emit(RegisterSuccess());
        }).onError((error, stackTrace) {
          emit(RegisterFailure(errorMsg: "some thing is wrong"));
        });
      }

  }


  void LoginUser (String emailController,String passwordController){
    emit(LoginLoading());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailController,
      password: passwordController,
    ).then((value) {
      emit(LoginSuccess());
    }).onError((error, stackTrace) {
      emit(LoginFailure());
    });
  }
}