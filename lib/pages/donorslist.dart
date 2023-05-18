import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:savelife/constants/dropdowns.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/functions/find_image.dart';
import 'package:url_launcher/url_launcher.dart';

class BloodDonor {
  final String firstName;
  final String lastName;
  final String bloodGroup;
  final String gender;
  final String city;
  final String phone;
  final String email;

  BloodDonor(this.firstName, this.lastName, this.bloodGroup, this.gender,
      this.city, this.phone, this.email);
}

class DonorList extends StatefulWidget {
  const DonorList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  List<BloodDonor> donors = [];
  List<String> bloodGroups = [
    'Select',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  String selectedBloodGroup = 'A+';
  String selectedLocation = '';
  List<String> locations = cityL;
  List<String> citiesList = cityL;

  @override
  void initState() {
    super.initState();
    _loadDonors();
  }

  void _loadDonors() {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('donors');
    collectionRef.snapshots().listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        donors.clear();
        locations.clear();
        // ignore: avoid_function_literals_in_foreach_calls
        snapshot.docs.forEach((DocumentSnapshot doc) {
          BloodDonor donor = BloodDonor(
            doc['first name'],
            doc['last name'],
            doc['blood group'],
            doc['gender'],
            doc['city'],
            doc['phone'],
            doc['email'],
          );
          donors.add(donor);
          if (!locations.contains(doc['city'])) {
            locations.add(doc['city']);
          }
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // leading: const Icon(Icons.menu),
        title: const Text(
          'Search Donors',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                bloodGroup,
                scale: 2.5,
              ),
              DropdownButton<String>(
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                value: selectedBloodGroup,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBloodGroup = newValue!;
                  });
                },
                items:
                    bloodGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const Icon(Icons.location_city_rounded,
                  color: Colors.redAccent, size: 30),

              //City Dropdown
              DropdownButton<String>(
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                value: selectedLocation,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedLocation = newValue!;
                  });
                },
                items: ['']
                    .followedBy(locations)
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                BloodDonor donor = donors[index];
                if (selectedBloodGroup != donor.bloodGroup ||
                    (selectedLocation.isNotEmpty &&
                        selectedLocation != donor.city)) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  child: SizedBox(
                    width: 320,
                    height: 210,
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
                                      findImage(donor.bloodGroup),
                                      scale: 3.2,
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
                                          path: "+977${donor.phone}",
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
                                      "${donor.firstName} ${donor.lastName}",
                                      style: txtTheme.displayMedium
                                          ?.apply(fontSizeFactor: 0.76),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Blood Group: ${donor.bloodGroup}",
                                      style: txtTheme.headlineMedium?.apply(
                                          fontSizeFactor: 0.9,
                                          color: Colors.red),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Gender: ${donor.gender}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 0.9),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "City: ${donor.city}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 0.9),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Phone: +977-${donor.phone}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 0.9),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Email: ${donor.email}",
                                      style: txtTheme.headlineMedium
                                          ?.apply(fontSizeFactor: 0.9),
                                    ),
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

                // return SizedBox(
                //   height: 200,
                //   child: Column(
                //     children: [
                //       Text(donor.firstName),
                //       SizedBox(height: 5),
                //       Text(donor.lastName),
                //       SizedBox(height: 10),
                //       Text(donor.city),
                //     ],
                //   ),
                // );
                // return ListTile(
                //   title: Text(donor.firstName),
                //   subtitle: Text(donor.bloodGroup + ' (' + donor.city + ')'),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
