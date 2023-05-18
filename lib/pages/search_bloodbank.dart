import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBloodbankPage extends StatefulWidget {
  const SearchBloodbankPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBloodbankPageState createState() => _SearchBloodbankPageState();
}

class _SearchBloodbankPageState extends State<SearchBloodbankPage> {
  final TextEditingController _searchController = TextEditingController();
  String name = '';
  final CollectionReference _referenceDonors =
      FirebaseFirestore.instance.collection('blood banks');
  late Stream<QuerySnapshot> _streamDonors;
  @override
  void initState() {
    super.initState();
    _streamDonors = _referenceDonors
        .orderBy('bloodbank name', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final txtTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Bloodbanks',
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by city name...',
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.red,
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red)),
              ),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder(
              stream: _streamDonors,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // ignore: prefer_const_constructors
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 250),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                //Variable Creations
                //requests stores all snapshot docs
                var donors = snapshot.data!.docs;

                //List View Building starts
                return ListView.builder(
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;

                    if (name.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: SizedBox(
                          width: 210,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.home,
                                            size: 45,
                                            color: Colors.red,
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
                                                path:
                                                    "+977${donors[index]['phone']}",
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
                                                  fontSize: 18,
                                                  letterSpacing: 0.6),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 15),

                                      //Blood bank name bg  etc

                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${donors[index]['bloodbank name']}",
                                              style: txtTheme.displayMedium
                                                  ?.apply(
                                                      fontSizeFactor: 0.8,
                                                      color:
                                                          Colors.indigo[800]),
                                            ),
                                            const SizedBox(height: 5),

                                            //City
                                            Row(
                                              children: [
                                                Text(
                                                  "City: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['city']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            //Full address
                                            Row(
                                              children: [
                                                Text(
                                                  "Full Address: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['full address']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            //Contact
                                            Row(
                                              children: [
                                                Text(
                                                  "Contact: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "+977-${donors[index]['phone']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),

                                            //Email
                                            Row(
                                              children: [
                                                Text(
                                                  "Email: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['email']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),

                                            //Blood Counts
                                            const SizedBox(height: 5),

                                            Row(
                                              children: [
                                                const SizedBox(height: 10),
                                                Column(
                                                  children: [
                                                    //A+ & A-
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "A+ Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['A+ Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //A- Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "A- Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['A- Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //B+ Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "B+ Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['B+ Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //B- Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "B- Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['B- Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 50),

                                                //2nd Column
                                                SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    children: [
                                                      //AB+ & AB-
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "AB+ Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['AB+ Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //AB- Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "AB- Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['AB- Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //O+ Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "O+ Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['O+ Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //O- Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "O- Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['O- Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }

                    if (data['city']
                        .toString()
                        .toLowerCase()
                        .startsWith(name.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: SizedBox(
                          width: 210,
                          height: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[300]),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.home,
                                            size: 45,
                                            color: Colors.red,
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
                                                path:
                                                    "+977${donors[index]['phone']}",
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
                                                  fontSize: 18,
                                                  letterSpacing: 0.6),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 15),

                                      //Blood bank name bg  etc

                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${donors[index]['bloodbank name']}",
                                              style: txtTheme.displayMedium
                                                  ?.apply(
                                                      fontSizeFactor: 0.8,
                                                      color:
                                                          Colors.indigo[800]),
                                            ),
                                            const SizedBox(height: 5),

                                            //City
                                            Row(
                                              children: [
                                                Text(
                                                  "City: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['city']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            //Full address
                                            Row(
                                              children: [
                                                Text(
                                                  "Full Address: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['full address']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            //Contact
                                            Row(
                                              children: [
                                                Text(
                                                  "Contact: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "+977-${donors[index]['phone']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),

                                            //Email
                                            Row(
                                              children: [
                                                Text(
                                                  "Email: ",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9),
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  "${donors[index]['email']}",
                                                  style: txtTheme.headlineMedium
                                                      ?.apply(
                                                          fontSizeFactor: 0.9,
                                                          color: Colors
                                                              .indigo[800]),
                                                ),
                                              ],
                                            ),

                                            //Blood Counts
                                            const SizedBox(height: 5),

                                            Row(
                                              children: [
                                                const SizedBox(height: 10),
                                                Column(
                                                  children: [
                                                    //A+ & A-
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "A+ Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['A+ Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //A- Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "A- Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['A- Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //B+ Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "B+ Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['B+ Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),

                                                    const SizedBox(height: 10),

                                                    //B- Count
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "B- Bags: ",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          "${donors[index]['B- Count']}",
                                                          style: txtTheme
                                                              .headlineMedium
                                                              ?.apply(
                                                                  fontSizeFactor:
                                                                      0.9,
                                                                  color: Colors
                                                                          .indigo[
                                                                      800]),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 50),

                                                //2nd Column
                                                SizedBox(
                                                  width: 100,
                                                  child: Column(
                                                    children: [
                                                      //AB+ & AB-
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "AB+ Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['AB+ Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //AB- Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "AB- Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['AB- Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //O+ Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "O+ Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['O+ Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(
                                                          height: 10),

                                                      //O- Count
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "O- Bags: ",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                        .red),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Text(
                                                            "${donors[index]['O- Count']}",
                                                            style: txtTheme
                                                                .headlineMedium
                                                                ?.apply(
                                                                    fontSizeFactor:
                                                                        0.9,
                                                                    color: Colors
                                                                            .indigo[
                                                                        800]),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
