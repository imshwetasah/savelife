import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:savelife/auth/profile_controller.dart';
import 'package:savelife/constants/colors.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/constants/sizes.dart';
import 'package:savelife/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:savelife/model/user_model.dart';
import 'package:savelife/model/user_repository.dart';
import 'package:savelife/pages/donorslist.dart';
import 'package:savelife/pages/hospitals_page.dart';
import 'package:savelife/pages/post_request_page.dart';
import 'package:savelife/pages/recent_requests_page.dart';
import 'package:savelife/pages/search_bloodbank.dart';
import 'package:savelife/widgets/dashboard_recent_request.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // This function calculates the distance between two locations
  Future<double> calculateDistance(
      double lat1, double long1, double lat2, double long2) async {
    double distanceInMeters =
        Geolocator.distanceBetween(lat1, long1, lat2, long2);
    return distanceInMeters / 1000; // Convert to kilometers
  }

// This function updates the distance field in Firebase
  Future<void> updateDistance() async {
    // Get the current user's location
    Position currentPosition = await Geolocator.getCurrentPosition();

    // Retrieve the hospitals from Firebase
    QuerySnapshot hospitalsSnapshot =
        await FirebaseFirestore.instance.collection('hospitals').get();

    // Loop through the hospitals and update the distance field in Firebase
    for (DocumentSnapshot hospitalSnapshot in hospitalsSnapshot.docs) {
      double hospitalLatitude = hospitalSnapshot.get('latitude');
      double hospitalLongitude = hospitalSnapshot.get('longitude');

      // Calculate the distance between the hospital and the user's location
      double distance = await calculateDistance(currentPosition.latitude,
          currentPosition.longitude, hospitalLatitude, hospitalLongitude);

      // Update the distance field in Firebase
      await hospitalSnapshot.reference.update({'distance': distance});
    }
  }

  final user = FirebaseAuth.instance.currentUser!;
  final _userRepo = UserRepository();
  getUserData() {
    final email = user.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    }
  }

  // //document IDs
  // List<String> docIDs = [];

  // //get DocIDs
  // Future getDocId() async {
  //   await FirebaseFirestore.instance
  //       .collection('donors')
  //       .orderBy('age', descending: true)
  //       .get()
  //       .then(
  //         (snapshot) => snapshot.docs.forEach(
  //           (document) {
  //             docIDs.add(document.reference.id);
  //           },
  //         ),
  //       );
  // }

  // @override
  // void initState() {
  //   getDocId();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // Variables
    final txtTheme = Theme.of(context).textTheme;
    final controller = ProfileController();

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.local_hospital),
        title: const Text(
          aAppName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
              },
              child: const Icon(
                Icons.logout_rounded,
                size: 25,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(aDashboardPadding),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  //Profile data
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Hey text
                      Text(
                        '$aDashboardTitle   ${userData.firstName}',
                        style: txtTheme.displayLarge?.apply(color: Colors.red),
                      ),

                      const SizedBox(height: 5),

                      //Find Donors text
                      Text(
                        aDashboardHeading,
                        style: txtTheme.bodyMedium?.copyWith(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: aDashboardPadding),

                      //4 - Buttons Dashboard
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Post Request
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const PostRequestPage();
                                    }));
                                  },
                                  // ignore: sort_child_properties_last
                                  label: Text(
                                    aDashboardPostRequest,
                                    style: txtTheme.headlineMedium?.apply(
                                        color: aWhiteColor,
                                        fontSizeFactor: 1.2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[900],
                                    side: const BorderSide(),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      aPostRequestImage,
                                      width: 35,
                                    ),
                                  ),
                                ),
                              ),

                              //Find Blood Bank
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return const SearchBloodbankPage();
                                      }),
                                    );
                                  },
                                  // ignore: sort_child_properties_last
                                  label: Text(
                                    aDashboardFindBloodBank,
                                    style: txtTheme.headlineMedium?.apply(
                                        color: aWhiteColor,
                                        fontSizeFactor: 1.2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      side: const BorderSide(),
                                      alignment: Alignment.centerLeft),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      aFindBloodBankImage,
                                      width: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          //2nd row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Search Donor
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const DonorList();
                                        },
                                      ),
                                    );
                                  },
                                  // ignore: sort_child_properties_last
                                  label: Text(
                                    aDashboardSearchDonors,
                                    style: txtTheme.headlineMedium?.apply(
                                        color: aWhiteColor,
                                        fontSizeFactor: 1.2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[900],
                                    side: const BorderSide(),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      aSearchDonorImage,
                                      width: 35,
                                    ),
                                  ),
                                ),
                              ),

                              //Nearby Hospitals
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    updateDistance();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        return const HospitalsPage();
                                      }),
                                    );
                                  },
                                  // ignore: sort_child_properties_last
                                  label: Text(
                                    aDashboardNearByHospitals,
                                    style: txtTheme.headlineMedium?.apply(
                                        color: aWhiteColor,
                                        fontSizeFactor: 1.2),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[900],
                                    side: const BorderSide(),
                                  ),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset(
                                      aFindHospitalImage,
                                      width: 35,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      //Recent Requests text
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            aDashboardRecentRequests,
                            style: txtTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red[800]),
                          ),
                          SizedBox(
                            width: 100,
                            height: 80,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: aWhiteColor)),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const RecentRequestPage();
                                }));
                              },
                              child: Text(
                                aDashboardButton,
                                style: txtTheme.displaySmall?.apply(
                                    fontSizeFactor: 1, color: Colors.red[700]),
                              ),
                            ),
                          )
                        ],
                      ),

                      //Recent requests list view
                      const DashboardRecentRequests(),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text('Something went wrong'));
                }
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 250.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         user.email!,
  //         style: TextStyle(fontSize: 14),
  //       ),
  //       actions: [
  //         GestureDetector(
  //             onTap: () {
  //               FirebaseAuth.instance.signOut();
  //             },
  //             child: const Icon(Icons.logout)),
  //       ],
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           FutureBuilder(
  //             future: getDocId(),
  //             builder: (context, snapshot) {
  //               return ListView.builder(
  //                 itemCount: docIDs.length,
  //                 itemBuilder: (context, index) => Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: ListTile(
  //                     title: GetUserName(documentId: docIDs[index]),
  //                     tileColor: Colors.lightBlue,
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
}
