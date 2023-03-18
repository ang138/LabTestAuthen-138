import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String? _name = '';
  String? _emailController = '';
  String? _tel = '';
  String? _type = '';

  Future _getDataFromDatabase() async{
    
    await FirebaseFirestore.instance.collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get()
    .then((snapshot) async
    {
      if(snapshot.exists){
        setState(() {
          _name = snapshot.data()!["fullname"];
          _emailController = snapshot.data()!["email"];
          _tel = snapshot.data()!["telephone"];
          _type = snapshot.data()!["type"];
        });
      }

    });

    void initState(){
      super.initState();
      _getDataFromDatabase();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            //addDataSection(),
            showOnetimeRead(),
            //showRealtimeChange(),
          ],
        ),
      )),
    );
  }

   showOnetimeRead() {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Text("Profile")),
          ],
        ),
        createOnetimeReadData(),
        const Divider(),
      ],
    );
  }

  createOnetimeReadData() {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").get(),
      builder: (context, snapshot) {
        print("Onetime");
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data!.docs);
          return Column(
            children: createDataList(snapshot.data),
          );
        } else {
          return const Text("Waiting Data");
        }
      },
    );
  }

  createDataList(QuerySnapshot<Map<String, dynamic>>? data) {
    List<Widget> widgets = [];
    widgets = data!.docs.map((doc) {
      var data = doc.data();
      print(data['email']);
      return ListTile(
        onTap: () {
          print(doc.id);
          // ดึงข้อมูล มาแสดง เพื่อแก้ไข
        },
        title: Text(
            data["ชื่อ" + 'fullname'] + "" + data["อีเมล์" + 'email']),

        
      );
    }).toList();

    return widgets;
  }

}