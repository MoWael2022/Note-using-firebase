import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/Authentication/sign_in.dart';
import 'package:untitled4/Home_screens/editnotes.dart';
import 'package:untitled4/Home_screens/notes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled4/Home_screens/profilepage.dart';
import 'package:untitled4/widgets/cardnotes.dart';
import 'package:untitled4/widgets/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });
  }

  String? user, phone, email, docid;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
          actions: [
            FutureBuilder(
              future: FirebaseFirestore.instance.collection("users")
                  .where(
                  "userid", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () {
                    user = snapshot.data?.docs[0].data()['username'];
                    phone = snapshot.data?.docs[0].data()['Phone'];
                    email = snapshot.data?.docs[0].data()['Email'];
                    docid = snapshot.data?.docs[0].id;
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(
                                  snapshot: snapshot,
                                  username: user,
                                  phone: phone,
                                  email: email,
                                  docid: docid,)
                        ),
                            (route) => false);
                  },
                  icon: Icon(Icons.person_outline_rounded),
                );
              },

            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return SignInPage();
                }));
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return NotesPage();
            }));
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("notes")
              .where("notes id",
              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, i) {
                    return Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        FirebaseFirestore.instance
                            .collection("notes")
                            .doc("${snapshot.data?.docs[i].id}")
                            .delete();
                      },
                      child: CardNotes(
                        title: "${snapshot.data?.docs[i].data()["title"]}",
                        subtitle: "${snapshot.data?.docs[i].data()["content"]}",
                        docid: "${snapshot.data?.docs[i].id}",
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
