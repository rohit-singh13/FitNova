import 'package:fitnova/features/auth/screens/Login.dart';
import 'package:fitnova/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnova/navigation/MainNavScreen.dart';
import 'package:fitnova/features/auth/screens/email_verification_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnova/data/user_data.dart';

class Signup extends StatefulWidget {
  final UserData userData;

  const Signup({super.key, required this.userData});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  bool _isPasswordHidden = true;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signupUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    if (!email.contains("@")) {
      _showError("Enter a valid email");
      return;
    }

    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$',   // Strong password validation: Minimum 10 chars, uppercase, lowercase, number, and special character required
    );

    if (!passwordRegex.hasMatch(password)) {
      _showError(
        "Password must be at least 10 characters and include:\n"
            "- 1 uppercase letter\n"
            "- 1 lowercase letter\n"
            "- 1 number\n"
            "- 1 special symbol (@, &, !, etc.)",
      );
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

        await user.sendEmailVerification();
        if (!mounted) return;
        Navigator.pushReplacement(context,
          MaterialPageRoute(
            builder: (_) => EmailVerificationScreen(),
          ),
        );
      }

    }
    on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Signup failed");
    }

    finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set({
          "name": user.displayName ?? "User",
          "email": user.email,
          "height": widget.userData.height,
          "weight": widget.userData.weight,
          "goal": widget.userData.goal,
          "experience": widget.userData.experience,
          "createdAt": FieldValue.serverTimestamp(),
          "bodyFat": widget.userData.bodyFat,
          "workoutDays": widget.userData.workoutDays,
        });
      }
      if (!mounted) return;

      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    }
    on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Signup failed");
    }
  }

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
                          color: Colors.white.withValues(alpha: 0.05),
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

                            TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Name",
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: nameController,
                            ),
                    
                            SizedBox(height: 15),

                            TextField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              controller: emailController,
                            ),
                    
                            SizedBox(height: 15),

                            TextField(
                              obscureText: _isPasswordHidden,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.white70),
                                helperText:
                                "must contain min 10 chars, uppercase, lowercase, numbers & symbols",
                                helperStyle: TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.05),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),

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
                                              builder: (context) => LoginScreen(),
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
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
