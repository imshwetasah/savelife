import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Hospital {
  final String name;
  final String phone;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  double distance;

  Hospital(
      {required this.name,
      required this.phone,
      required this.city,
      required this.address,
      required this.latitude,
      required this.longitude,
      this.distance = 0});
}

class HospitalsPage extends StatefulWidget {
  const HospitalsPage({super.key});

  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  final CollectionReference _referenceHospitals =
      FirebaseFirestore.instance.collection('hospitals');
  late Stream<QuerySnapshot> _streamHospitals;

  //geo

  double? distanceInMeter = 0.0;
  // HospitalData allHospitalData = HospitalData();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('hospitals');
  final List<Hospital> hospitals = [];

  // Future _getTheDistance() async {
  //   _currentUserPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   // distanceInMeter = await Geolocator.distanceBetween(
  //   //   _currentUserPosition!.latitude,
  //   //   _currentUserPosition!.longitude,
  //   //   storelat,
  //   //   storelong,
  //   // );
  //   print('distance between is $distanceInMeter');
  // }
  // Future _getTheDistance(double hLatitude, double hLongitude) async {
  //   _currentUserPosition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   distanceInMeter = Geolocator.distanceBetween(_currentUserPosition!.latitude,
  //       _currentUserPosition!.longitude, hLatitude, hLongitude);
  //   print('distance between is $distanceInMeter');
  //   var distance = distanceInMeter?.round().toInt();
  //   return distance;
  // }

  // final Position currentUserPosition =
  //     Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //         as Position;

  // final double currentUserLatitude = currentUserPosition.latitude;

  @override
  void initState() {
    // _getTheDistance;
    _streamHospitals =
        _referenceHospitals.orderBy('distance', descending: false).snapshots();
    super.initState();
    // _getHospitals();
  }

  // Future<void> _getHospitals() async {
  //   final Position position = await Geolocator.getCurrentPosition();
  //   final double userLat = position.latitude;
  //   final double userLng = position.longitude;

  //   final snapshot = await collectionReference.get();
  //   if (snapshot.docs.isEmpty) return;

  //   for (final doc in snapshot.docs) {
  //     final data = doc.data();
  //     final hospital = Hospital(
  //       name: data['name'],
  //       phone: data['phone'],
  //       city: data['city'],
  //       address: data['address'],
  //       latitude: data['latitude'],
  //       longitude: data['longitude'],

  //     );

  //     final double distance = Geolocator.distanceBetween(
  //         userLat, userLng, hospital.latitude, hospital.longitude);
  //     hospital.distance = distance;

  //     await doc.reference.update({'distance': distance});
  //     hospitals.add(hospital);
  //   }

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: const Text(
          'Nearby Hospitals',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: StreamBuilder(
        stream: _streamHospitals,
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
          final hospital = snapshot.data!.docs;
          // .map((doc) {
          //   //changing the distance here
          //   newDistance = _getTheDistance()
          //   final newData = doc.data()['distance'] = newvalue;
          // });

          //List View Building starts
          return ListView.builder(
            itemCount: hospital.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: SizedBox(
                  width: 320,
                  height: 200,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${hospital[index]['hospital name']}",
                                style: txtTheme.displayMedium?.apply(
                                    fontSizeFactor: 0.8,
                                    color: Colors.indigo[800]),
                              ),
                              const SizedBox(height: 5),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      const Icon(
                                        Icons.local_hospital,
                                        size: 60,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        height: 50,
                                        width: 60,
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
                                                    "+977${hospital[index]['phone']}",
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
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Phone
                                      Text(
                                        "Phone: ${hospital[index]['phone']}",
                                        style: txtTheme.headlineMedium?.apply(
                                            fontSizeFactor: 1,
                                            color: Colors.red),
                                      ),
                                      const SizedBox(height: 5),
                                      //City
                                      Text(
                                        "City: ${hospital[index]['city']}",
                                        style: txtTheme.headlineMedium
                                            ?.apply(fontSizeFactor: 1),
                                      ),
                                      const SizedBox(height: 5),
                                      //Address
                                      Text(
                                        "Address: ${hospital[index]['address']}",
                                        style: txtTheme.headlineMedium
                                            ?.apply(fontSizeFactor: 1),
                                      ),
                                      const SizedBox(height: 10),

                                      //Distance
                                      Text(
                                        "${(hospital[index]['distance']).toStringAsFixed(2)} KM away",
                                        style: txtTheme.headlineMedium?.apply(
                                            fontSizeFactor: 1,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.orange.shade800),
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 25)
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
