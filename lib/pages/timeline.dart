import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttershare/widgets/header.dart';
import 'package:fluttershare/widgets/progress.dart';

final usersRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {

  List<dynamic> users = [];

  initState(){
    super.initState();
    getUsers();
    updateUser();
  }

  createUser() async{
    await usersRef.add({
      'username' : 'Joo',
      'postsCount' : 0,
      'isAdmin' : true
    });
  }

  updateUser() async{
    final DocumentSnapshot doc = await usersRef.document('Lr07UDFpSObsc2Bmw9fv').get();
    if(doc.exists){
      doc.reference.updateData({
        'username' : doc.data['username'],
        'postsCount' : doc.data['postsCount'],
        'isAdmin' : true
      });
    }
  }

  deleteUser() async{
   final DocumentSnapshot doc = await usersRef.document('').get();
   if(doc.exists){
     doc.reference.delete();
   }
  }


  getUsers() async{
   final QuerySnapshot snapshot = await usersRef.getDocuments();
   setState(() {
     users = snapshot.documents;
   });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return circularProgress();
          }

          final List<Text> children = snapshot.data.documents.map((doc) => Text(doc['username'])).toList();

          return Container(
            child: ListView(
              children: children
            ),
          );
        },
      )
    );
  }
}
