import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savelife/constants/constant.dart';
import 'package:savelife/constants/dropdowns.dart';
import 'package:savelife/constants/image_strings.dart';
import 'package:savelife/constants/text_strings.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Constructor for selection
  _RegisterPageState() {
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _genderController = TextEditingController();
  final _bloodgroupController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _genderController.dispose();
    _bloodgroupController.dispose();
    _phoneController.dispose();
    _cityController.dispose();

    super.dispose();
  }

  Future signUp() async {
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
      if (passwordConfirmed()) {
        try {
          // create donor
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          //add donor details
          addDonorDetails(
            _firstnameController.text.trim(),
            _lastnameController.text.trim(),
            _cityController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
            _genderController.text.trim(),
            _bloodgroupController.text.trim(),
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
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text(
                'Passwords doesn\'t match !',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future addDonorDetails(
    String firstName,
    String lastName,
    String city,
    String email,
    String phone,
    String gender,
    String bloodGroup,
  ) async {
    var user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('donors').doc(user.uid).set(
      {
        'first name': firstName,
        'last name': lastName,
        'city': city,
        'email': email,
        'phone': phone,
        'gender': gender,
        'blood group': bloodGroup,
      },
    );
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
      {
        'name': '$firstName $lastName',
        'city': city,
        'email': email,
        'phone': phone,
        'role': 'donor',
      },
    );
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmpasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Title Image Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Get On Board!',
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      color: Colors.red[800],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    'Register below to be a donor!',
                    style: GoogleFonts.figtree(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),

              //Sign Up Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //First Name Text Field
                          SizedBox(
                            height: 60,
                            width: screenSize.width * 0.41,
                            child: TextField(
                              controller: _firstnameController,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4),
                              decoration: InputDecoration(
                                label: const Text(
                                  'First Name',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  color: Colors.red,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),

                          //Last Name Text Field
                          SizedBox(
                            height: 60,
                            width: screenSize.width * 0.41,
                            child: TextField(
                              controller: _lastnameController,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4),
                              decoration: InputDecoration(
                                label: const Text(
                                  '  Last Name',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Gender
                          SizedBox(
                            height: 60,
                            width: screenSize.width * 0.41,
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),

                          //Blood Group Drop Down
                          SizedBox(
                            height: 60,
                            width: screenSize.width * 0.41,
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // City Drop Down
                      SizedBox(
                        height: 60,
                        width: screenSize.width * 0.60,
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
                      // Email Text Field
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            aEmail,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
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

                      //Password Text Field
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            aPassword,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: const Icon(
                            Icons.fingerprint_rounded,
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

                      //Confirm Password
                      TextField(
                        obscureText: true,
                        controller: _confirmpasswordController,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.4,
                        ),
                        decoration: InputDecoration(
                          label: const Text(
                            aConfirmPassword,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: const Icon(
                            Icons.fingerprint_rounded,
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

                      //Sign in button
                      GestureDetector(
                        onTap: signUp,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: kred,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Sign Up',
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

              //I'm a donor! Login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'I\'m a donor!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: Text(
                      '  Login now',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
