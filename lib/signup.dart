import 'package:fitnova/Login.dart';
import 'package:fitnova/app_background.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnova/MainNavScreen.dart';
import 'package:fitnova/email_verification_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnova/user_data.dart';
import 'package:fitnova/signup.dart';

class signup extends StatefulWidget {
  final UserData userData;

  signup({required this.userData});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  bool _isPasswordHidden = true;
  bool isLoading = false;

  //variables
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //function
  Future<void> signupUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // ✅ SAVE DATA TO FIRESTORE
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
          "name": nameController.text.trim(),
          "email": email,
          "height": widget.userData.height,
          "weight": widget.userData.weight,
          "goal": widget.userData.goal,
          "experience": widget.userData.experience,
          "createdAt": FieldValue.serverTimestamp(),
          "bodyFat": widget.userData.bodyFat,
          "workoutDays": widget.userData.workoutDays,
        });

        // 🔥 Send verification email
        await user.sendEmailVerification();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationScreen(),
          ),
        );
      }

    } catch (e) {
      print("SIGNUP ERROR: $e"); // 👈 VERY IMPORTANT
      _showError(e.toString());
    }

    setState(() => isLoading = false);
  }
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // 🔥 Save (or update) user in Firestore
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "height": widget.userData.height,
          "weight": widget.userData.weight,
          "goal": widget.userData.goal,
          "experience": widget.userData.experience,
          "createdAt": FieldValue.serverTimestamp(),
          "bodyFat": widget.userData.bodyFat,
          "workoutDays": widget.userData.workoutDays,
        });
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      print("GOOGLE ERROR: $e");
      _showError(e.toString());
    }
  }
  //Error Dialog
  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back, color: Colors.red),
                        ),
                        Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: LinearProgressIndicator(
                              value: 0.80,
                              backgroundColor: Colors.red,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                    
                            Center(
                              child: Text(
                                "Almost There!",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    
                            SizedBox(height: 25),
                    
                            // Name
                            TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: nameController,
                            ),
                    
                            SizedBox(height: 15),
                    
                            // Email
                            TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: emailController,
                            ),
                    
                            SizedBox(height: 15),
                    
                            // Password
                            TextField(
                              obscureText: _isPasswordHidden,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                // 👇 THIS IS THE IMPORTANT PART
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white54,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordHidden = !_isPasswordHidden;
                                    });
                                  },
                                ),
                              ),
                              controller: passwordController,
                            ),
                    
                            SizedBox(height: 25),
                    
                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: Color(0xFF6C5CE7), // modern purple
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: isLoading ? null : signupUser,
                                child: isLoading
                                    ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ),
                    
                            SizedBox(height: 15),
                    
                            // Login text
                            Center(
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(color: Colors.white60),
                                  children: [
                                    TextSpan(
                                      text: "Log in",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginScreen(), // 👈 your login screen
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    
                            SizedBox(height: 20),
                    
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.white24)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text("or", style: TextStyle(color: Colors.white54)),
                                ),
                                Expanded(child: Divider(color: Colors.white24)),
                              ],
                            ),
                    
                            SizedBox(height: 20),
                    
                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: Colors.white30),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: signInWithGoogle,
                                child: Text(
                                  "Continue with Google",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
