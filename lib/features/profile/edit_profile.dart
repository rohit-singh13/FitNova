import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  bool isLoading = true;

  //Loads existing user profile data when screen starts
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {   //Fetches current user profile data from Firestore
    User? user = FirebaseAuth.instance.currentUser;   //Checks if user is logged in

    if (user == null) return;

    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();

    if (doc.exists) {   //Fills text fields with saved profile data
      var data = doc.data()!;

      nameController.text = data["name"] ?? "";
      heightController.text = (data["height"] ?? "").toString();
      weightController.text = (data["weight"] ?? "").toString();
      fatController.text = data["bodyFat"] != null
          ? data["bodyFat"].toString()
          : "";

      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {    //Updates edited profile data in Firestore
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    int? fat = int.tryParse(fatController.text);    //Converts body fat input into integer

    if (nameController.text.isEmpty || heightController.text.isEmpty || weightController.text.isEmpty) {    //Validates required fields before updating
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    await FirebaseFirestore.instance    //Saves updated values to Firebase database
        .collection("users")
        .doc(user.uid)
        .update({
      "name": nameController.text.trim(),
      "height": int.tryParse(heightController.text),
      "weight": int.tryParse(weightController.text),
      "bodyFat": fatController.text.isEmpty ? null : fat,
    });
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              style: TextStyle(
                color: Colors.white70,
              ),
              decoration: InputDecoration(labelText: "Name", labelStyle: TextStyle(color: Colors.white)),
            ),

            SizedBox(height: 20,),

            TextField(
              controller: heightController,
              style: TextStyle(
                color: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Height (cm)", labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20,),

            TextField(
              controller: weightController,
              style: TextStyle(
                color: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Weight (kg)", labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20,),

            TextField(
              controller: fatController,
              style: TextStyle(
                color: Colors.white70,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Body Fat % (optional)", labelStyle: TextStyle(color: Colors.white)),
            ),


            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: updateProfile,
                child: Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}