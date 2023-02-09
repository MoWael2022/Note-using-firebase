import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled4/Home_screens/home.dart';
import 'dart:io';

import '../widgets/loading.dart';

class ProfilePage extends StatefulWidget {
  final docid, username, phone, email, snapshot;

  const ProfilePage(
      {Key? key,
      this.docid,
      this.email,
      this.phone,
      this.username,
      this.snapshot})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var ref;
  File? image;
  var url;
  var defaultimage = "https://i.stack.imgur.com/l60Hf.png";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text("${widget.username}")),
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(5.w, 3.h, 5.w, 3.h),
          children: [
            InkWell(
              onTap: () {
                showModalBottomSheet(context: context, builder: (context) {
                  return SizedBox(
                    height: 25.h,
                    child: Column(
                      children: [
                        Text(
                          "Please Choose Image",
                          style: TextStyle(
                            fontSize: 8.w,
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        Card(
                          color : Colors.white54,
                          child: InkWell(
                            onTap: ()async {

                              final picked =await ImagePicker().pickImage(source: ImageSource.camera);
                              if (picked != null){
                                image = File(picked.path);
                                var rand =Random().nextInt(100000);
                                var imagename =rand.toString() + basename(picked.path);
                                ref =FirebaseStorage.instance.ref("images").child("$imagename}");

                              }

                            },
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenl,
                              children:  [
                                Icon(Icons.camera_alt_outlined,size: 8.w,),
                                Text("Camera",style: TextStyle(
                                  fontSize: 10.w,
                                ),)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        Card(
                          color: Colors.white54,
                          child: InkWell(
                            onTap: ()async {
                              final picked =await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (picked != null){
                                image = File(picked.path);
                                var rand =Random().nextInt(100000);
                                var imagename =rand.toString() + basename(picked.path);
                                ref =FirebaseStorage.instance.ref("images").child("$imagename}");
                              }

                            },
                            child: Row(

                              //mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:  [
                                Icon(Icons.image_outlined,size: 8.w,),
                                Text("Gallery",style: TextStyle(
                                  fontSize: 10.w,
                                ),)
                              ],
                            ),
                          ),
                        )

                      ],

                    ),
                  );
                });
              },
              child: SizedBox(
                height: 30.h,
                width: 30.h,
                child: CircleAvatar(
                  backgroundImage: NetworkImage("${defaultimage}"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
