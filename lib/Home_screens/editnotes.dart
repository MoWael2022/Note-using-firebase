import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled4/Home_screens/home.dart';
import 'dart:io';

import '../widgets/loading.dart';

class EditNotesPage extends StatefulWidget {
  final String docid, title, subtitle;

  EditNotesPage({Key? key, required this.docid, required this.subtitle, required this.title})
      : super(key: key);

  @override
  State<EditNotesPage> createState() => _EditNotesPageState();
}

class _EditNotesPageState extends State<EditNotesPage> {
  var ref;

  File? image;


  TextEditingController? notescontroller;
  TextEditingController? titlecontroller;



  GlobalKey<FormState> formstate = new GlobalKey<FormState>();


  @override
  void initState() {
    print(widget.docid);
    print(widget.title);
    print(widget.subtitle);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('EditNotes'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: (){
              FirebaseFirestore.instance.collection("notes").doc(widget.docid).delete();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context){
                return HomePage();
              }));
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(3.h),
        children: [
          Form(
            key: formstate,
            child: Column(
              children: [
                TextFormField(
                  controller: titlecontroller=new TextEditingController(text: "${widget.title}"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Required";
                    }
                  },

                  decoration: const InputDecoration(
                    labelText: "Note Title",
                    prefixIcon: Icon(Icons.title_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 3.h,
                ),
                SizedBox(
                  // <--- SizedBox
                  height: 30.h,
                  child: TextFormField(

                    controller: notescontroller=new TextEditingController(text: "${widget.subtitle}"),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Required";
                      }
                    },
                    // onSaved: (val){
                    //   notescon = val;
                    // },
                    // // initialValue: "${widget.subtitle}",

                    cursorColor: Colors.red,
                    maxLines: 30.h ~/ 20,
                    // <--- maxLines
                    decoration: const InputDecoration(
                      hintText: "Notes",
                      prefixIcon: Icon(Icons.note),
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2.h,
          ),
          Column(
            children: [
              SizedBox(
                height: 5.h,
                width: 60.w,
                child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
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
                                    color: Colors.white54,
                                    child: InkWell(
                                      onTap: () async {
                                        final picked = await ImagePicker()
                                            .pickImage(
                                            source: ImageSource.camera);
                                        if (picked != null) {
                                          image = File(picked.path);
                                          var rand = Random().nextInt(100000);
                                          var imagename = rand.toString() +
                                              basename(picked.path);
                                          ref = FirebaseStorage.instance.ref(
                                              "images").child("$imagename}");
                                        }
                                      },
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceEvenl,
                                        children: [
                                          Icon(Icons.camera_alt_outlined,
                                            size: 8.w,),
                                          Text("Camera", style: TextStyle(
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
                                      onTap: () async {
                                        final picked = await ImagePicker()
                                            .pickImage(
                                            source: ImageSource.gallery);
                                        if (picked != null) {
                                          image = File(picked.path);
                                          var rand = Random().nextInt(100000);
                                          var imagename = rand.toString() +
                                              basename(picked.path);
                                          ref = FirebaseStorage.instance.ref(
                                              "images").child("$imagename}");
                                        }
                                      },
                                      child: Row(

                                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.image_outlined, size: 8.w,),
                                          Text("Gallery", style: TextStyle(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [Text("Add Images"), Icon(Icons.image)],
                    )),
              ),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
          SizedBox(
            height: 8.h,
            child: ElevatedButton(
              onPressed: () async {
                if (formstate.currentState?.validate() == true) {
                  Loading(context);
                  if (image != null) {
                    await ref.putFile(image);
                    var url = await ref.getDownloadURL();
                  }
                  FirebaseFirestore.instance.collection("notes").doc(widget.docid).update({
                    "title": titlecontroller?.text,
                    "content": notescontroller?.text,
                    "notes id": FirebaseAuth.instance.currentUser?.uid,
                  });
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return HomePage();
                      }));
                }
              },
              child: const Text('Edit Notes'),
            ),
          ),

        ],
      ),
    );
  }
}
