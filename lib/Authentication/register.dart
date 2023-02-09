import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled4/Authentication/sign_in.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_bloc.dart';
import 'package:untitled4/busniss_logic/auth_bloc/auth_event.dart';

import 'package:untitled4/widgets/loading.dart';
import 'package:untitled4/widgets/text_filed.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

import '../Home_screens/home.dart';
import '../busniss_logic/auth_bloc/auth_state.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  late UserCredential user;
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController Usernamecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController confirmpasswordcontroller = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              isLoading = true;
            } else if (state is RegisterSuccess) {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: "Successfully Register",
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
            } else if (state is RegisterFailure) {
              isLoading = false;
              Fluttertoast.showToast(
                  msg: state.errorMsg,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
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
                    size: 30.w,
                    color: Colors.blueAccent,
                  ),
                ),
                Form(
                  key: formstate,
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val!.isEmpty) {
                            return "required";
                          }
                        },
                        controller: Usernamecontroller,
                        string: "Name",
                      ),
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val!.isEmpty) {
                            return "required";
                          }
                        },
                        controller: emailcontroller,
                        string: "Email",
                      ),
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val!.isEmpty) {
                            return "required";
                          }
                          // else if (val.length < 4) {
                          //   return "the password is weak";
                          // }
                        },
                        controller: passwordcontroller,
                        string: "Password",
                      ),
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val!.isEmpty) {
                            return "required";
                          }
                        },
                        controller: confirmpasswordcontroller,
                        string: "Confirm Password",
                      ),
                      SizedBox(height: 3.h),
                      TextFormfield(
                        Validator: (val) {
                          if (val!.isEmpty) {
                            return "required";
                          } else if (val.length != 11) {
                            return "the phone number must be 11";
                          }
                        },
                        controller: phone,
                        string: "phone number",
                      )
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: () {
                      //Loading(context);
                      if (formstate.currentState?.validate() == true) {
                        formstate.currentState?.save();
                        //user= BlocProvider.of<AuthCubit>(context).user!;
                        // BlocProvider.of<AuthCubit>(context).RegisterUser(
                        //     passwordcontroller.text,
                        //     emailcontroller.text,
                        //     confirmpasswordcontroller.text,
                        //     Usernamecontroller.text,
                        //     phone.text,
                        //     );

                        BlocProvider.of<AuthBloc>(context).add(RegisterEvent(
                            phone: phone.text,
                            confirmPassword: confirmpasswordcontroller.text,
                            passwordController: passwordcontroller.text,
                            emailController: emailcontroller.text,
                            userNameController: Usernamecontroller.text));
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
                      'Register',
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
                        return SignInPage();
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
                      'Sign In',
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
