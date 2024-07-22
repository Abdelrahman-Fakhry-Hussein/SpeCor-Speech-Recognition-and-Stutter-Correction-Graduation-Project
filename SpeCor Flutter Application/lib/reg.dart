import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/const.dart';
import 'package:specor/home.dart';
import 'package:specor/login.dart';
import 'firebase/auth.dart';
import 'package:specor/user_model.dart';
import 'dart:math';

class Register extends StatefulWidget{
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  TextEditingController email=TextEditingController();
  TextEditingController image=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController pass=TextEditingController();
  bool isLoading = false;

// Generate a unique id for the user


// Then use this id when creating the User_model object


  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text("Register"),
      ),
      body: isLoading
          ? Center(
        child: Container(

          child: CircularProgressIndicator(),
        ),
      )
          :  Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column
                (
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/SpeCor - Graduation Project.png",width: 300.w,height: 250.h,),

                  TextFormField
                    (
                    controller: name,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'name',
                        hintStyle: TextStyle(color: Colors.grey),

                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        fillColor: Colors.grey.shade800,
                        filled: true
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField
                    (
                    controller: email,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),

                        hintText: 'email',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        fillColor: Colors.grey.shade800,
                        filled: true
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField
                    (
                    controller: pass,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),

                        hintText: 'password',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        fillColor: Colors.grey.shade800,
                        filled: true
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  TextFormField
                    (controller: image,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey),

                        hintText: 'image',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black87)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey)
                        ),
                        fillColor: Colors.grey.shade800,
                        filled: true
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  InkWell(onTap: (){
    if (name.text.isNotEmpty &&
    email.text.isNotEmpty &&
    pass.text.isNotEmpty) {
    setState(() {
    isLoading = true;
    });

    createAccount(name.text, email.text, pass.text,image.text).then((user) {
    if (user != null) {
    setState(() {
    isLoading = false;
    });
    Navigator.push(
    context, MaterialPageRoute(builder: (_) => Home()));
    print("Account Created Sucessfull");
    } else {
    print("Login Failed");
    setState(() {
    isLoading = false;
    });
    }
    });
    } else {
    print("Please enter Fields");
    }
    },
                  // auth.reg(email.text, pass.text, name.text, image.text);
                    // setState(() {
                    //   current_user=users[users.indexWhere((element) => element.email==email.text)];
                    // });
                   // Navigator.push(context, MaterialPageRoute(builder: (c)=>Home()));
       //       },
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
                            :  Center(child: Text('Register',style: TextStyle
                          (color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17.sp),)),
                      ),
                    ),
                  ),
                  InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  },
                    child:  Padding(
                      padding: const EdgeInsets.only(right: 15,left: 15),
        child: Container(
              width: MediaQuery.of(context).size.width,

              decoration: BoxDecoration(
                  color: Color(0xff35fab1),
                  border: Border.all(color: Colors.grey.shade800),
                  borderRadius: BorderRadius.circular(15)
              ),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
              child: Center(child: Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17.sp),)),
        ),
      ),
                  ),

                ],
              ),
            ),
          )
      ),
    );
  }
}