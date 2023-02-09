import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_event.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc():super(AuthInitial()){
    on<AuthEvent>((event, emit) async{
      if(event is LoginEvent){
        emit(LoginLoading());
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        ).then((value) {
          emit(LoginSuccess());
        }).onError((error, stackTrace) {
          emit(LoginFailure());
        });
      }else if (event is RegisterEvent) {

        emit(RegisterLoading());

        if (event.passwordController != event.confirmPassword) {
          emit(RegisterFailure(errorMsg: 'Password doesn\'t Match'));
        } else {
         await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: event.emailController,
            password: event.passwordController,
          )
              .then((value) {
            UserCredential user = value;
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
    });
  }


}


