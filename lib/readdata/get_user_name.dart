import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

class GetUserName extends StatelessWidget {
  final String documentId;
  const GetUserName({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    //get collection
    CollectionReference donors =
        FirebaseFirestore.instance.collection('donors');
    return FutureBuilder<DocumentSnapshot>(
      future: donors.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          // ignore: prefer_interpolation_to_compose_strings
          return Text('${data['first name']}'
              ' '
              '${data['last name']}'
              ', '
              '${data['age']}'
              ' years old');
        }
        return const Text('Loading...');
      }),
    );
  }
}
