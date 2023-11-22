import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //--------------------------------------------------------------------------------

  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;
//--------------------------------------------------------------------------------

  startAuthentication() {
    final validity = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formkey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    // final authResult;
    try {
      if (isLoginPage) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        final credentials = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = credentials.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email});
      }
    } catch (e) {
      print("error - $e");
    }
  }
//--------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            height: 200,
            child: Image.asset('assets/todo.png'),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      !isLoginPage
                          ? TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              key: const ValueKey('username'),
                              validator: (value) {
                                if (value.toString().isEmpty) {
                                  return 'Incorrect Username';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value.toString();
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide()),
                                  labelText: "Enter Username",
                                  labelStyle: GoogleFonts.roboto(),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.pink)),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.pink)),
                              cursorColor: Colors.pink)
                          : Container(),
                      const SizedBox(height: 10),
                      TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          key: const ValueKey('email'),
                          validator: (value) {
                            if (value.toString().isEmpty ||
                                !value.toString().contains('@')) {
                              return 'Incorrect Email';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _email = value.toString();
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide()),
                              labelText: "Enter Email",
                              labelStyle: GoogleFonts.roboto(),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink)),
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.pink)),
                          cursorColor: Colors.pink),
                      const SizedBox(height: 10),
                      TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.emailAddress,
                          key: const ValueKey('password'),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Incorrect password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _password = value.toString();
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide()),
                              labelText: "Enter Password",
                              labelStyle: GoogleFonts.roboto(),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink)),
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.pink)),
                          cursorColor: Colors.pink),
                      const SizedBox(height: 10),
                      Container(
                          padding: const EdgeInsets.all(5),
                          width: double.infinity,
                          height: 70,
                          child: ElevatedButton(
                            onPressed: () {
                              startAuthentication();
                            },
                            style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll(Colors.pink),
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))))),
                            child: isLoginPage
                                ? Text('Login',
                                    style: GoogleFonts.roboto(fontSize: 16))
                                : Text('SignUp',
                                    style: GoogleFonts.roboto(fontSize: 16)),
                          )),
                      const SizedBox(height: 10),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isLoginPage = !isLoginPage;
                            });
                          },
                          child: isLoginPage
                              ? Text(
                                  'Not a member?',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, color: Colors.white),
                                )
                              : Text('Already a Member?',
                                  style: GoogleFonts.roboto(
                                      fontSize: 16, color: Colors.white)))
                    ],
                  )))
        ],
      ),
    );
  }
}
