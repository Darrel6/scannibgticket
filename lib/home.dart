import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanning_ticket/login.dart';
import 'package:scanning_ticket/scanner.dart';
import 'package:scanning_ticket/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isElevated = false;
  bool isLoading = false;
  Color boxColor = const Color(0XFFa3e635);
  String? fullname = "";

  getUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      fullname = pref.getString("fullname");
    });
  }

  Future<void> logout() async {
    isLoading = true;
    setState(() {});
    try {
      Map<String, dynamic> response = await logAuth.signout();
      log('dbvhfghvgfhghghgergeeeeee---hg: ${response["data"]}');

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove("token");
      await pref.remove("fullname");
      // await pref.setString("identity", response["data"]['user']['identity']);
      await pref.remove("email");
      await pref.remove("userid");

      // permissions = jsonEncode(response["data"]['user']['permissions']);
      // await pref.setString("permissions", permissions!);

      // for (var permission in response["data"]['user']['permissions']) {
      //   if (permission['resource'] == "examen") {
      //     has_permission = true;
      //     await pref.setBool("has_permission", has_permission);
      //   }
      //   if (permission['resource'] == "visite_technique") {
      //     can_visite = true;
      //     await pref.setBool("can_visite", can_visite);
      //   }
      //   if (permission['resource'] == "visite_classement") {
      //     can_visite_classement = true;
      //     await pref.setBool("can_visite_classement", can_visite_classement);
      //   }
      // }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Login()),
        (route) => false,
      );
      isLoading = false;
      setState(() {});
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("dsfdssq $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   setState(() {
    //     _isElevated = !_isElevated;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Salut, $fullname!",
                    style: TextStyle(
                      color: const Color(0xFF000000),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lato().fontFamily,
                      letterSpacing: 2,
                      fontVariations: [
                        const FontVariation('ital', 0),
                        const FontVariation('wght', 600),
                        const FontVariation('ital', 1),
                        const FontVariation('wght', 600)
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ScannerScreen(),
                        ));
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(20),
                          color: boxColor,
                          boxShadow: _isElevated
                              ? [
                                  // Echo shadow effect using color variants
                                  BoxShadow(
                                    color: boxColor
                                        .withOpacity(0.4), // Darker variant
                                    spreadRadius: 0,
                                    blurRadius: 15,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: boxColor.withOpacity(0.3),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: boxColor.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 25,
                                    offset: const Offset(0, 12),
                                  ),
                                  BoxShadow(
                                    color: boxColor
                                        .withOpacity(0.1), // Lighter variant
                                    spreadRadius: 0,
                                    blurRadius: 30,
                                    offset: const Offset(0, 16),
                                  ),
                                ]
                              : [
                                  BoxShadow(
                                    color: boxColor.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: boxColor.withOpacity(0.15),
                                    spreadRadius: 0,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: boxColor.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Color(0xFF000000),
                              size: 50,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Scanner un QR\n code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: const Color(0xFF000000),
                                  fontFamily: GoogleFonts.lato().fontFamily,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  logout();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  fixedSize: const Size(double.infinity, 50.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 0.0,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15.0,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(
                        color: Colors.red,
                      )),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Color(0xFFe6c068),
                          )
                        : const Text(
                            "Se déconnecter",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
