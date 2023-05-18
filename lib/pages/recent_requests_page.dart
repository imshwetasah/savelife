import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savelife/functions/find_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:z_time_ago/z_time_ago.dart';

class RecentRequestPage extends StatefulWidget {
  const RecentRequestPage({super.key});

  @override
  State<RecentRequestPage> createState() => _RecentRequestPageState();
}

class _RecentRequestPageState extends State<RecentRequestPage> {
  // ignore: prefer_final_fields
  CollectionReference _referenceBloodRequests =
      FirebaseFirestore.instance.collection('blood request');
  late Stream<QuerySnapshot> _streamBloodRequests;
  @override
  void initState() {
    super.initState();
    _streamBloodRequests = _referenceBloodRequests
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // var _numberToMonthMap = {
  //   1: "Jan",
  //   2: "Feb",
  //   3: "Mar",
  //   4: "Apr",
  //   5: "May",
  //   6: "Jun",
  //   7: "Jul",
  //   8: "Aug",
  //   9: "Sep",
  //   10: "Oct",
  //   11: "Nov",
  //   12: "Dec",
  // };

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: const Text(
          'All Requests',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _streamBloodRequests,
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

          //List View Building starts
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              Timestamp date = snapshot.data!.docs[index]['timestamp'];
              var finalDate = DateTime.parse(date.toDate().toString());
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
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
                                    scale: 3.1,
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
                                      final Uri url = Uri(
                                        scheme: 'tel',
                                        path: "+977${requests[index]['phone']}",
                                      );
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } //else {
                                      //   print('cannot launch');
                                      // }
                                    },
                                    child: const Text(
                                      'Call',
                                      style: TextStyle(
                                          fontSize: 18, letterSpacing: 0.6),
                                    ),
                                  )
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
            },
          );
        },
      ),
    );
  }
}


// ListTile(
//               leading: const Icon(Icons.person),
//               title: Text(requests[index]['full name']),
//               subtitle: Text('${requests[index]['blood group']} required'),
//             ),

//inside body
// FirestoreListView(
//             query: FirebaseFirestore.instance
//                 .collection('blood request')
//                 .orderBy('timestamp', descending: true),
//             loadingBuilder: (_) => CircularProgressIndicator(),
//             itemBuilder: (context, snapshot) {
//               Map<String, dynamic> data =
//                   snapshot.data() as Map<String, dynamic>;
//               Timestamp t = data['timestamp'] as Timestamp;
//               DateTime date = t.toDate();
//               return Container(
//                 child: Text(
//                     'Posted on: ${_numberToMonthMap[date.month]} ${date.day} ${date.year}'),
//               );
//             }));
