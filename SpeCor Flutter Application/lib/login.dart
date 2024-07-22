import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/firebase/auth.dart';
import 'package:specor/home.dart';
import 'package:specor/reg.dart';
import 'package:get/get.dart';
import 'package:specor/specor_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'const.dart';
class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  TextEditingController email=TextEditingController();
  TextEditingController pass=TextEditingController();
  bool isLoading = false;

  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     backgroundColor: Colors.black,
     appBar: AppBar(
       title: Text("Login"),
       backgroundColor: Colors.black87,centerTitle: true,
     ),
     body: Container(
       color: Colors.black,
       child: SingleChildScrollView(
         child: Column
           (
           mainAxisAlignment: MainAxisAlignment.start,
           children: [
             Image.asset("assets/SpeCor - Graduation Project.png",width: 300.w,height: 250.h,),
             Padding(padding: EdgeInsets.all(15),
               child: TextFormField
                 (
controller: email,
                 style: TextStyle(color: Colors.white),
                 cursorColor: Colors.black,
                 decoration: InputDecoration(
                   hintText: "email",
                   hintStyle: TextStyle(color: Colors.grey),
                   focusedBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide(color:  Color(0xFF4f81bd))),
                   enabledBorder: OutlineInputBorder(
                     borderRadius: BorderRadius.circular(10),
                     borderSide: BorderSide(color: Color(0xFF4f81bd))
                   ),
                   fillColor: Colors.grey.shade800,
                   filled: true
                 ),
               ),
             ),
             Padding(padding: EdgeInsets.all(15),
               child: TextFormField
                 (
                 controller: pass,
                 style: TextStyle(color: Colors.white),
                 cursorColor: Colors.black,
                 decoration: InputDecoration(
                     hintText: "password",
                     hintStyle: TextStyle(color: Colors.grey),
                     focusedBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: BorderSide(color: Colors.black87)
                     ),
                     enabledBorder: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(10),
                         borderSide: BorderSide(color: Colors.grey)
                     ),
                     fillColor: Colors.grey.shade800,
                     filled: true
                 ),
               ),
             ),
             InkWell(onTap: (){
               if (email.text.isNotEmpty && pass.text.isNotEmpty) {
                 setState(() {
                   isLoading = true;
                 });

                 logIn(email.text, pass.text).then((user) {
                   if (user != null) {
                     print("Login Sucessfull");
                     setState(() {
                       isLoading = false;
                     });
                     Navigator.push(
                         context, MaterialPageRoute(builder: (_) => Home()));
                   } else {
                     print("Login Failed");
                     setState(() {
                       isLoading = false;
                     });
                   }
                 });
               } else {
                 print("Please fill form correctly");
               }


             },
             child: Padding(
               padding: const EdgeInsets.all(15),
               child: Container(
width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff4f81bd),
                 border: Border.all(color: Colors.grey.shade800),
                  borderRadius: BorderRadius.circular(15)
                ),
                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                 child:isLoading
                     ? Center(
                   child: Container(

                     child: CircularProgressIndicator(),
                   ),
                 )
                     :  Center(child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17.sp),)),
               ),
             ),
             ),
             SizedBox(height: 10.h,),
             InkWell(onTap: (){
               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Register()));

               },
               child: Padding(
                 padding: const EdgeInsets.only(right: 15,left: 15),
                 child: Container(
                   width: MediaQuery.of(context).size.width,

                   decoration: BoxDecoration(
                       color: Color(0xff35fab1),
                       border: Border.all(color: Colors.grey.shade800),
                       borderRadius: BorderRadius.circular(15)
                   ),
                   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                   child: Center(child: Text('Register',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17.sp),)),
                 ),
               ),
             )
           ],
         ),
       )
     ),
   );
  }
}