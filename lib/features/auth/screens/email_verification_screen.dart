import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitnova/features/auth/registration/age_and_gender.dart';
import 'package:fitnova/core/widgets/app_background.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isLoading = false;   // Prevents multiple verification checks while previous request is processing

  Future<void> checkEmailVerified() async {
    setState(() => isLoading = true);

    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AgeAndGender()),
      );
    } else {
      _showMessage("Still not verified. Please check your email.");
    }

    setState(() => isLoading = false);
  }

  Future<void> resendEmail() async {
    try {
      await FirebaseAuth.instance.currentUser
          ?.sendEmailVerification();
      _showMessage("Verification email sent again!");
    } catch (e) {
      _showMessage("Error sending email");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
        backgroundColor: Colors.transparent,
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mark_email_read,
                  color: Colors.white, size: 80),
        
              SizedBox(height: 20),
        
              Text(
                "Check your email",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
        
              SizedBox(height: 10),
        
              Text(
                "We sent a verification link to your email.\nPlease verify to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60),
              ),
        
              SizedBox(height: 30),
        
              ElevatedButton(
                onPressed: isLoading ? null : checkEmailVerified,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("I've Verified", style: TextStyle(color: Colors.white)),
              ),
        
              SizedBox(height: 10),
        
              TextButton(
                onPressed: resendEmail,
                child: Text(
                  "Resend Email",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}