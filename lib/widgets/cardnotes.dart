import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled4/Home_screens/editnotes.dart';


class CardNotes extends StatelessWidget {
  CardNotes({Key? key,required this.title,required this.subtitle,required this.docid}) : super(key: key);

  String title,subtitle,docid;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: ListTile(
          title: Text(title,style: TextStyle(
            fontSize: 6.w,
          ),),
          subtitle: Text(subtitle),
          trailing: IconButton(
           icon: Icon(Icons.edit),
            onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder:(context){
               return EditNotesPage(docid:docid,title: title,subtitle: subtitle,);
             }));
            },
          ),
        ),
      ),
    );
  }
}
