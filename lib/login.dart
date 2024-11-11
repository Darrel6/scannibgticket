import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanning_ticket/home.dart';
import 'package:scanning_ticket/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isLoading = false;
  bool showPassword = false;
  bool has_permission = false;

  String? permissions;
  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      try {
        Map<String, dynamic> response =
            await logAuth.signIn(email.text, password.text);
        log('dbvhfghvgfhghghgergeeeeee---hg: ${response["data"]}');

        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString("token", response["data"]['token']);
        await pref.setString("fullname", response["data"]['user']['fullname']);
        // await pref.setString("identity", response["data"]['user']['identity']);
        await pref.setString("email", response["data"]['user']['email']);
        await pref.setInt("userid", response["data"]['user']['id']);

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
          MaterialPageRoute(builder: (context) => const Home()),
          (route) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Connexion réussie"),
            backgroundColor: Colors.green.withOpacity(0.8)));
        isLoading = false;
        setState(() {});
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Email ou mot de passe incorrect"),
            backgroundColor: Colors.red.withOpacity(0.8)));
        log("dsfdssq $e");
      }
    }
  }

  // Function to check email validity using regex
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  // Function to check password validity using regex
  bool isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFe3ecf1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.lato().fontFamily,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ce champ est requis';
                          }
                          if (!isValidEmail(value)) {
                            return 'Veuillez saisir une adresse email valide';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Veuillez saisir votre email',
                          label: Text('Email'),
                          hintStyle: TextStyle(fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(193, 162, 230, 53))),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !showPassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ce champ est requis';
                          }
                          /* if (!isValidPassword(value)) {
                            return 'Le mot de passe doit contenir au moins 8 caractères, '
                                'dont au moins une majuscule, une minuscule, un chiffre et un caractère spécial.';
                          } */
                          return null;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Veuillez saisir votre mot de passe',
                          label: const Text('Mot de Passe'),
                          hintStyle: const TextStyle(fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(193, 162, 230, 53))),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          fixedSize: const Size(double.infinity, 50.0),
                          backgroundColor: isLoading
                              ? Color.fromARGB(137, 162, 230, 53)
                              : const Color(0xFFa3e635),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 0.0,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 15.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isLoading
                                ? const CircularProgressIndicator(
                                    color: Color(0xFF000000),
                                  )
                                : const Text(
                                    "Se connecter",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
