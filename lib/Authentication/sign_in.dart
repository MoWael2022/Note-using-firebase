import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled4/Authentication/register.dart';
import 'package:untitled4/Home_screens/home.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_bloc.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_event.dart';


import 'package:untitled4/widgets/loading.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:untitled4/widgets/text_filed.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../busniss_logic/auth_bloc/auth_state.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);

  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              isLoading = true;
            } else if (state is LoginSuccess) {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: "Successfully Login",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                  (route) => false);
            } else if (state is LoginFailure) {
              Fluttertoast.showToast(
                  msg: "Invalid E-mail or Password",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
              isLoading = false;
            }
          },
          builder: (context, state) => ModalProgressHUD(
            inAsyncCall: isLoading,
            child: ListView(
              padding: EdgeInsets.fromLTRB(2.w, 4.h, 2.w, 1.h),
              children: [
                Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.blueAccent,
                    size: 50.w,
                  ),
                ),
                SizedBox(height: 3.h),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      TextFormfield(
                        Validator: (val) {
                          if (val.isEmpty) {
                            return "please enter your Email";
                          }
                        },
                        controller: emailcontroller,
                        string: "Email",
                      ),
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val.isEmpty) {
                            return "please enter your Email";
                          }
                        },
                        controller: passwordcontroller,
                        string: "Password",
                      ),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forget Password?',
                      style: TextStyle(
                        fontSize: 5.w,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      Loading(context);
                      if (formstate.currentState?.validate() == true) {
                        //BlocProvider.of<AuthCubit>(context).LoginUser(emailcontroller.text, passwordcontroller.text);
                        BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                            email: emailcontroller.text,
                            password: passwordcontroller.text));

                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 7.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return RegisterPage();
                      }));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 7.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
