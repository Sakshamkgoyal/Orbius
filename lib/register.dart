import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'map.dart';

import 'auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final _authenticate = FirebaseAuth.instance;
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors:[
                  Color(0xff027373),
                  Color(0xff50BF77),
                ]
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Register',style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10),
                  Text('Welcome Aboard',style: TextStyle(color: Colors.white, fontSize: 20),),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), topRight: Radius.circular(60.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50,),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x5050BF77),
                                  blurRadius: 20,
                                  offset: Offset(0,10)
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                              ),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value){
                                  email = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[200]))
                              ),
                              child: TextField(
                                obscureText: true,
                                onChanged: (value){
                                  password = value;
                                },
                                decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0,),
                      GestureDetector(
                        onTap: () async {
                          try {
                            print(email);
                            print(password);
                            final newUser = await _authenticate
                                .createUserWithEmailAndPassword(
                                email: email, password: password);
                            if (newUser != null){
                              Navigator.push(context,  MaterialPageRoute(builder: (context)=>map()));
                            }
                          }
                          catch(e){
                            print(e);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 500,
                          margin: EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xff027373)
                          ),
                          child: Center(child: Text("Sign Up", style: TextStyle(color: Colors.white,fontSize: 25 ,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle().whenComplete(() => Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                            return map();
                          })));
                        },
                        child: Container(
                          height: 50,
                          width: 500,
                          margin: EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xff50BF77)
                          ),
                          child: Center(child: Text("SignUp with Google", style: TextStyle(color: Colors.white,fontSize: 20 ,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
