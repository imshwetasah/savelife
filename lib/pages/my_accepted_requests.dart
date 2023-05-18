import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savelife/functions/find_image.dart';
import 'package:z_time_ago/z_time_ago.dart';

class MyAcceptedRequests extends StatefulWidget {
  const MyAcceptedRequests({super.key});

  @override
  State<MyAcceptedRequests> createState() => _MyAcceptedRequestsState();
}

class _MyAcceptedRequestsState extends State<MyAcceptedRequests> {
  // ignore: prefer_final_fields
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference _referenceMyBloodRequests =
      FirebaseFirestore.instance.collection('fulfilled requests');
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
          'Fulfilled Requests',
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
