import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:savelife/constants/colors.dart';
import 'package:savelife/functions/find_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:z_time_ago/z_time_ago.dart';

class DashboardRecentRequests extends StatefulWidget {
  const DashboardRecentRequests({super.key});

  @override
  State<DashboardRecentRequests> createState() =>
      _DashboardRecentRequestsState();
}

class _DashboardRecentRequestsState extends State<DashboardRecentRequests> {
  final CollectionReference _referenceBloodRequests =
      FirebaseFirestore.instance.collection('blood request');
  late Stream<QuerySnapshot> _streamBloodRequests;
  @override
  void initState() {
    super.initState();
    _streamBloodRequests = _referenceBloodRequests
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 230,
      child: StreamBuilder(
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
                //for min ago
                Timestamp date = snapshot.data!.docs[index]['timestamp'];
                var finalDate = DateTime.parse(date.toDate().toString());
                return SizedBox(
                  width: 330,
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, top: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: aCardBgColor),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 30),
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
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ElevatedButton(
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
                                            path:
                                                "+977${requests[index]['phone']}",
                                          );
                                          if (await canLaunchUrl(url)) {
                                            await launchUrl(url);
                                          } //else {
                                          //   print('cannot launch');
                                          // }
                                        },
                                        child: const Icon(Icons.call)),
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
                                    requests[index]['full name'],
                                    style: txtTheme.displaySmall
                                        ?.apply(fontSizeFactor: 0.9),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Blood Required: ${requests[index]['blood group']}",
                                    style: txtTheme.headlineMedium?.apply(
                                        fontSizeFactor: 1, color: Colors.red),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "City: ${requests[index]['city']}",
                                    style: txtTheme.headlineMedium
                                        ?.apply(fontSizeFactor: 1),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Contact: +977-${requests[index]['phone']}",
                                    style: txtTheme.headlineMedium
                                        ?.apply(fontSizeFactor: 0.9),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Posted ${ZTimeAgo().getTimeAgo(date: finalDate, language: Language.english)}",
                                    style: txtTheme.bodySmall?.copyWith(
                                        fontSize: 14,
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
                );
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            );
          }),
    );
  }
}
