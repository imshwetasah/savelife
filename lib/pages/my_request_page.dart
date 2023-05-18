import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:savelife/pages/index_page.dart';
import 'package:z_time_ago/z_time_ago.dart';

import '../functions/find_image.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({super.key});

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  // ignore: prefer_final_fields
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference _referenceMyBloodRequests =
      FirebaseFirestore.instance.collection('blood request');
  late Stream<QuerySnapshot> _streamMyBloodRequests;
  @override
  void initState() {
    super.initState();
    _streamMyBloodRequests = _referenceMyBloodRequests
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: const Text(
          'My Requests',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _streamMyBloodRequests,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // ignore: prefer_const_constructors
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 250),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          //Variable Creations
          //requests stores all snapshot docs
          var requests = snapshot.data!.docs;
          var flag = 0;

          //List View Building starts
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              Timestamp date = snapshot.data!.docs[index]['timestamp'];
              var finalDate = DateTime.parse(date.toDate().toString());
              var docId = snapshot.data!.docs[index].id;
              if (requests[index]['added by user'] ==
                  FirebaseAuth.instance.currentUser!.email) {
                flag++;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: SizedBox(
                    width: 320,
                    height: 270,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[300]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Image.asset(
                                      findImage(requests[index]['blood group']),
                                      scale: 2.8,
                                    ),
                                    const SizedBox(height: 15),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 0.0,
                                          side: const BorderSide(
                                              color: Colors.transparent),
                                          backgroundColor:
                                              Colors.lightGreen.shade500),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('fulfilled requests')
                                            .doc()
                                            .set({
                                          'added by user': requests[index]
                                              ['added by user'],
                                          'blood group': requests[index]
                                              ['blood group'],
                                          'city': requests[index]['city'],
                                          'full name': requests[index]
                                              ['full name'],
                                          'gender': requests[index]['gender'],
                                          'hospital': requests[index]
                                              ['hospital'],
                                          'phone': requests[index]['phone'],
                                          'remarks': requests[index]['remarks'],
                                          'timestamp': requests[index]
                                              ['timestamp'],
                                          'status': 'fulfilled',
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('blood request')
                                            .doc(docId)
                                            .delete();
                                        DelayedMultiDragGestureRecognizer;
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const IndexPage();
                                        }));
                                        // ignore: use_build_context_synchronously
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return const AlertDialog(
                                              content: Text(
                                                'Request Marked as Fulfilled Successfully!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.done_rounded,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          elevation: 0.0,
                                          side: const BorderSide(
                                              color: Colors.transparent),
                                          backgroundColor: Colors.red.shade900),
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('blood request')
                                            .doc(docId)
                                            .delete();
                                      },
                                      icon: const Icon(Icons.delete_forever),
                                      label: const SizedBox(),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 25),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${requests[index]['full name']}",
                                      style: txtTheme.displayMedium
                                          ?.apply(fontSizeFactor: 0.9),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Blood Required: ${requests[index]['blood group']}",
                                      style: txtTheme.headlineMedium?.apply(
                                          fontSizeFactor: 1, color: Colors.red),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Gender: ${requests[index]['gender']}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 1),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "City: ${requests[index]['city']}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 1),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Contact: +977-${requests[index]['phone']}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 1),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Hospital: ${requests[index]['hospital']}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 1),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Remarks: ${requests[index]['remarks']}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 1),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Posted: ${ZTimeAgo().getTimeAgo(date: finalDate, language: Language.english)}",
                                      style: txtTheme.bodySmall?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.orange.shade800),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else if (flag == 0 && index == requests.length - 1) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: const Center(
                    child: Text(
                      "No Requests Found!",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                );
              } else {
                return const SizedBox(height: 0);
              }
            },
          );
        },
      ),
    );
  }
}
