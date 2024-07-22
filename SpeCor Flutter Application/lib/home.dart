import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/chat1.dart';
import 'package:specor/const.dart';
import 'package:get/get.dart';
import 'package:specor/model_chat.dart';
import 'package:specor/specor_model.dart';
import 'package:specor/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'data_controller.dart';
import 'firebase/auth.dart';
import 'login.dart';
class Home  extends StatefulWidget{
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  FirebaseAuth auth =FirebaseAuth.instance;

  Data_controller controller=Get.put(Data_controller());
double redius=0.0;
List chats=[];
void initState(){
  get_data();
  super.initState();


}
  Widget build(BuildContext context) {

    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(redius),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: Icon(Icons.add,color: Colors.white,),
          onPressed: (){
            All_users(context);
          },
        ),
        appBar: AppBar(
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Text('Logout'),
                      value: 'Logout',
                    ),

                  ];
                },
                onSelected: (value) {
                  if (value == 'Logout') {
                    logOut(context).then((user) {
                      if (user == null) {
                        print("Logged out Sucessfull");

                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) => Login()));
                      } else {
                        print("Logged out Failed");
                        // Perform logout action here
                        // For example, navigate to logout screen or call logout function
                      }
                    });
                  }})
            ],
            backgroundColor:
        Colors.black87,
        elevation: 0,
        centerTitle: true,
        title: GetBuilder<Data_controller>(
          init: Data_controller(),
          builder: (controller)=>Text( "Welcome Back ${controller.Current_User==null?'':controller.Current_User.name}",style: TextStyle
            (color: Colors.white,fontWeight: FontWeight.w800,fontSize: 17.sp)),

        )),
        body: Container(
          color: Colors.black,
          child: Column(children:
          chats.map((e) =>
              Chat_item(SpeCor_model.from_json(e))).toList(),)



          ),
        ),

    );}
Widget Chat_item(SpeCor_model chat){
  User_model user=chat.users[chat.users.indexWhere((e) => e.id!=auth.currentUser!.uid)];
   print(user.image);
  return Column(children: [
    SizedBox(height: 10.h,),
  ListTile(onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Chat_1(chat)));
  },
  leading:user.image==''?CircleAvatar(backgroundImage: AssetImage("assets/avatar.png",),radius: 30,) :CircleAvatar(radius: 30.sp,backgroundImage: NetworkImage(user.image,),backgroundColor: Colors.white,),
                      title: Text(user.name,style: TextStyle(
                          color: Colors.white,fontWeight: FontWeight.bold
                      ),),
    subtitle:chat.chat.isNotEmpty && chat.chat.last["kind"]=="text"? Text( chat.chat.last["text"],style: TextStyle(color: Colors.white),):chat.chat.isNotEmpty && chat.chat.last["kind"]=="audio"?Text('voice message',style: TextStyle(color: Colors.blue)):Text(''),
                    ),

                  Divider(color: Colors.white,)

                ],
              );}
All_users(context){
    showModalBottomSheet(context: context, builder: (b)=>IntrinsicHeight(child: Container(
      color: Colors.black87,
      child: SingleChildScrollView(
        child: GetBuilder<Data_controller>(
          builder:(c)=>Column(
            children: c.users.map((e)=>Column(children: [
              ListTile(
                onTap: ()async{
                  await add_new_chat([c.Current_User,e]);
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                leading: e.image!=''?CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(e.image),
                ):CircleAvatar(backgroundImage: AssetImage("assets/avatar.png",)),
                title: Text(e.name,style: TextStyle(color: Colors.white),),
              )
            ],)).toList(), // Convert iterable to list
          ),
        ),
      ),
    ),));
  }

  add_new_chat(List <User_model> users)async{
  CollectionReference ref =FirebaseFirestore.instance.collection('chats');
  await ref.add(SpeCor_model(id:'id' , users: users, chat: [], users_id: users.map((e) => e.id).toList()).to_json()).then((value) async{
   await value.update({'id':value.id});
  });
  setState(() {

  });

  }
  get_data()async{
 await FirebaseFirestore.instance.collection('chats').snapshots().listen((event) {
 chats=event.docs.toList();


   setState(() {

   });
 });}}

