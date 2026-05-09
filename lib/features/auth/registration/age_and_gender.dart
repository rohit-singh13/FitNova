import 'package:fitnova/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnova/navigation/MainNavScreen.dart';
import 'package:flutter/services.dart';

class AgeAndGender extends StatefulWidget {
  @override
  State<AgeAndGender> createState() => _AgeAndGenderState();
}

class _AgeAndGenderState extends State<AgeAndGender> {

  TextEditingController ageController = TextEditingController();
  String? selectedGender;
  bool isLoading = false;

  Future<void> saveDataAndContinue() async {
    if (ageController.text.isEmpty || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    int? age = int.tryParse(ageController.text);

    if (age == null || age < 10 || age > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter valid age")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .update({
          "age": age,
          "gender": selectedGender!.toLowerCase(),
        });
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data")),
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Column(
          children: [

            // 🔴 TOP BAR
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                          value: 1,
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

            // 🟢 CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    SizedBox(height: 30),

                    // AGE
                    Text(
                      'Your Age',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Age',
                        hintStyle: TextStyle(color: Colors.white54),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    // GENDER
                    Text(
                      'Your Gender',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      hint: Text("Select Gender", style: TextStyle(color: Colors.white54)),
                      style: TextStyle(color: Colors.white),
                      value: selectedGender,
                      dropdownColor: Colors.black,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      items: ["Male", "Female", "Others"].map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e, style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedGender = value);
                      },
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // 🔵 BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveDataAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6C5CE7),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Finish', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}