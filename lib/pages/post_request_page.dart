import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savelife/constants/constant.dart';
import 'package:savelife/constants/dropdowns.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/constants/text_strings.dart';
import 'package:savelife/pages/index_page.dart';

class PostRequestPage extends StatefulWidget {
  const PostRequestPage({super.key});

  @override
  State<PostRequestPage> createState() => _PostRequestPageState();
}

class _PostRequestPageState extends State<PostRequestPage> {
  //Constructor for selection
  _PostRequestPageState() {
    _selectedgenderL = _genderL[0];
    _selectedBloodGroupL = _bloodGroupL[0];
    _selectedCityL = _cityL[0];
  }

  // For Dropdown selection
  final _bloodGroupL = [
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
  String? _selectedBloodGroupL = '';

  final _genderL = ['Select', 'Male', 'Female', 'Others'];
  String? _selectedgenderL = '';

  final _cityL = cityL;
  String? _selectedCityL = '';

  //text Controllers
  final _fullnameController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodgroupController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _remarksController = TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _genderController.dispose();
    _bloodgroupController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _hospitalController.dispose();
    _remarksController.dispose();

    super.dispose();
  }

  Future postRequest() async {
    //Check if blood group and gender field is empty
    if ((_bloodgroupController.text.trim() == '' &&
            _cityController.text.trim() == '' &&
            _genderController.text.trim() == '') ||
        (_bloodgroupController.text.trim() == 'Select' &&
            _cityController.text.trim() == 'Select' &&
            _genderController.text.trim() == 'Select') ||
        (_bloodgroupController.text.trim() == 'Select' &&
            _cityController.text.trim() == 'Select' &&
            _genderController.text.trim() == '') ||
        (_bloodgroupController.text.trim() == 'Select' &&
            _cityController.text.trim() == '' &&
            _genderController.text.trim() == '') ||
        (_bloodgroupController.text.trim() == '' &&
            _cityController.text.trim() == 'Select' &&
            _genderController.text.trim() == 'Select') ||
        (_bloodgroupController.text.trim() == '' &&
            _cityController.text.trim() == '' &&
            _genderController.text.trim() == 'Select') ||
        (_bloodgroupController.text.trim() == 'Select' &&
            _cityController.text.trim() == '' &&
            _genderController.text.trim() == 'Select') ||
        (_bloodgroupController.text.trim() == '' &&
            _cityController.text.trim() == 'Select' &&
            _genderController.text.trim() == '') ||
        (_bloodgroupController.text.trim() == '' ||
            _bloodgroupController.text.trim() == 'Select') ||
        (_cityController.text.trim() == '' ||
            _cityController.text.trim() == 'Select') ||
        (_genderController.text.trim() == '' ||
            _genderController.text.trim() == 'Select')) {
      //check if blood group field is empty
      if (_bloodgroupController.text.trim() == '' ||
          _bloodgroupController.text.trim() == 'Select') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Please select a Blood Group !',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        );
      }
      //Check if city field is empty
      else if (_cityController.text.trim() == '' ||
          _cityController.text.trim() == 'Select') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Please select a City!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        );
      }

      //Check if gender field is empty
      else if (_genderController.text.trim() == '' ||
          _genderController.text.trim() == 'Select') {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Please select a Gender!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        );
      }
    } else {
      try {
        //add blood Request details
        addBloodRequest(
          _fullnameController.text.trim(),
          _cityController.text.trim(),
          _phoneController.text.trim(),
          _genderController.text.trim(),
          _bloodgroupController.text.trim(),
          _hospitalController.text.trim(),
          _remarksController.text.trim(),
        );

        DelayedMultiDragGestureRecognizer;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const IndexPage();
        }));
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Request Posted Successfully!',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          },
        );
      }
    }
  }

  Future addBloodRequest(
    String fullName,
    String city,
    String phone,
    String gender,
    String bloodGroup,
    String hospital,
    String remarks,
  ) async {
    await FirebaseFirestore.instance.collection('blood request').doc().set(
      {
        'full name': fullName,
        'city': city,
        'phone': phone,
        'gender': gender,
        'blood group': bloodGroup,
        'hospital': hospital,
        'remarks': remarks,
        'timestamp': FieldValue.serverTimestamp(),
        'added by user': FirebaseAuth.instance.currentUser!.email,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Title Image Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                Text(
                  'Post a Request',
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    color: Colors.red[800],
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.6,
                  ),
                ),
                Text(
                  'Please enter patient\'s details below!',
                  style: GoogleFonts.figtree(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            //Post Request Form
            Form(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                child: Column(
                  children: [
                    //Full Name
                    TextField(
                      controller: _fullnameController,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4),
                      decoration: InputDecoration(
                        label: const Text(
                          'Full Name',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: Colors.red,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 15),
                    // Gender
                    SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        value: _selectedgenderL,
                        items: _genderL
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedgenderL = val as String;
                            _genderController.text = val;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                        ),
                        alignment: Alignment.bottomCenter,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4),
                        decoration: InputDecoration(
                          prefixIcon: Image.asset(
                            gender,
                            scale: 2,
                          ),
                          label: const Text(
                            'Gender',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    //Blood Group Drop Down
                    SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        value: _selectedBloodGroupL,
                        items: _bloodGroupL
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedBloodGroupL = val as String;
                            _bloodgroupController.text = val;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                        ),
                        alignment: Alignment.bottomCenter,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4),
                        decoration: InputDecoration(
                          prefixIcon: Image.asset(
                            bloodGroup,
                            scale: 3,
                          ),
                          label: const Text(
                            'Blood Group',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // City Drop Down
                    SizedBox(
                      height: 60,
                      child: DropdownButtonFormField(
                        value: _selectedCityL,
                        items: _cityL
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedCityL = val as String;
                            _cityController.text = val;
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                        ),
                        alignment: Alignment.bottomCenter,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.location_city_rounded,
                            color: Colors.red,
                            size: 27,
                          ),
                          label: const Text(
                            aCity,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    //Phone Number Text Field
                    TextField(
                      controller: _phoneController,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          aPhone,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_iphone_rounded,
                          color: Colors.red,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 15),

                    //Hospital
                    TextField(
                      controller: _hospitalController,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Hospital\'s Name',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        prefixIcon: const Icon(
                          Icons.gps_fixed,
                          color: Colors.red,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 15),

                    //Remarks
                    TextField(
                      controller: _remarksController,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.4,
                      ),
                      decoration: InputDecoration(
                        label: const Text(
                          'Remarks',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        prefixIcon: const Icon(
                          Icons.note_add,
                          color: Colors.red,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                    ),

                    const SizedBox(height: 15),

                    //Post Request button
                    GestureDetector(
                      onTap: postRequest,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kred,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'Post Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
