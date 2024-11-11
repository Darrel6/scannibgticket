import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanning_ticket/home.dart';
import 'package:scanning_ticket/services/scanning_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultCheck extends StatefulWidget {
  final reference;
  const ResultCheck({super.key, required this.reference});

  @override
  State<ResultCheck> createState() => _ResultCheckState();
}

class _ResultCheckState extends State<ResultCheck> {
  bool is_valid = false;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkTicket();
  }

  Future<void> checkTicket() async {
    isLoading = true;
    try {
      Map<String, dynamic> response =
          await scanningService.checkTicket(widget.reference);
      log('response $response');
      if (response != null) {
        Map<String, dynamic> check =
            await scanningService.validTicket(response['data']['id']);
        log('check $check');
      }

      isLoading = false;
      is_valid = true;
      setState(() {});
    } catch (e) {
      isLoading = false;
      is_valid = false;
      setState(() {});
      log("dsfdssq $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLoading == false
                  ? Container(
                      child: Column(
                        children: [
                          is_valid == true
                              ? Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                )
                              : Container(
                                  width: 150,
                                  height: 150,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 100,
                                  ),
                                ),
                          const SizedBox(height: 20),
                          is_valid == true
                              ? Text("Ticket valide",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ))
                              : Text("Ticket invalide",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  )),
                          const SizedBox(
                            height: 60,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const Home()),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              fixedSize: const Size(double.infinity, 50.0),
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 0.0,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Retour à l'accueil",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontFamily: GoogleFonts.lato().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : const CircularProgressIndicator(
                      color: Color(0xFFe6c068),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
