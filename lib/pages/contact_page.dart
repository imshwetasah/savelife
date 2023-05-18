import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:savelife/constants/colors.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/constants/text_strings.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
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
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Center(
          child: Column(children: [
            const SizedBox(height: 20),
            SizedBox(
              height: 120,
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const Image(image: AssetImage(VITlogo)),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aAccentColor.withOpacity(0.2),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(Icons.person_2, color: Colors.red),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Dev - 1",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: aDarkColor),
                        ),
                      ],
                    ),
                  )),
            ),
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
              title: const Text(
                "sudeep.chaudhary2019@vitstudent.ac.in",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
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
              title: const Text(
                "+91 - 9629248737",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),

            //Dev 2
            const Divider(),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: aAccentColor.withOpacity(0.2),
                    side: BorderSide.none,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const Icon(Icons.person_2, color: Colors.red),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Dev - 2",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: aDarkColor),
                        ),
                      ],
                    ),
                  )),
            ),
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
              title: const Text(
                "shweta.sah2019@vitstudent.ac.in",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
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
              title: const Text(
                "+91 - 6385327882",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
