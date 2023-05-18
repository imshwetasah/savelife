import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savelife/auth/profile_controller.dart';
import 'package:savelife/constants/colors.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/constants/text_strings.dart';
import 'package:savelife/functions/find_image.dart';
import 'package:savelife/model/user_model.dart';
import 'package:savelife/model/user_repository.dart';
import 'package:savelife/pages/my_accepted_requests.dart';
import 'package:savelife/pages/my_request_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserRepository();
  getUserData() {
    final email = user!.email;
    if (email != null) {
      return _userRepo.getUserDetails(email);
    }
  }

  // ignore: non_constant_identifier_names
  DateConverter(String date) {
    String newDate = '';
    for (int i = 0; i < 10; i++) {
      newDate += date[i];
    }
    return newDate;
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.local_hospital),
        // leading: const Icon(Icons.menu),
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
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(
                Icons.logout_rounded,
                size: 25,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: FutureBuilder(
            future: controller.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  //Profile data
                  return Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 1),
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: Image(
                            image: AssetImage(findImage(userData.bloodGroup))),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: const Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 0.5,
                                color: aDarkColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Created on: ${DateConverter(user!.metadata.creationTime.toString())}",
                        style: const TextStyle(
                          color: Colors.brown,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Divider(),
                      //Information
                      //Name
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: aAccentColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.person_2,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          "${userData.firstName}  ${userData.lastName}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),
                      //Email
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: aAccentColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.mail,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          userData.email,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),

                      //Blood Group
                      ListTile(
                        leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: aAccentColor.withOpacity(0.1),
                            ),
                            child: Image.asset(
                              bloodGroup,
                              scale: 3,
                            )),
                        title: Text(
                          userData.bloodGroup,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),

                      //Gender
                      ListTile(
                        leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: aAccentColor.withOpacity(0.1),
                            ),
                            child: Image.asset(
                              gender,
                              scale: 2,
                            )),
                        title: Text(
                          userData.gender,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),

                      //City
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: aAccentColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.location_city,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          userData.city,
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),

                      //Phone
                      ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: aAccentColor.withOpacity(0.1),
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.red,
                          ),
                        ),
                        title: Text(
                          "+977-${userData.phone}",
                          style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const MyAcceptedRequests();
                                }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    '   Fulfilled Req  ',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Icon(Icons.checklist_rounded),
                                  const SizedBox(width: 10),
                                ],
                              )),
                          const SizedBox(width: 20),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                elevation: 0.0,
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const MyRequestPage();
                                }));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  const Text(
                                    '   Live Req   ',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  const Icon(Icons.notifications_active),
                                  const SizedBox(width: 10),
                                ],
                              )),
                        ],
                      )
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
}
