import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specor/user_model.dart';
class Firebase_get{
  Future <User_model> get_current_user(id)async{
    CollectionReference ref=FirebaseFirestore.instance.collection('users');
    var value=await ref.doc(id).get();
    return User_model.from_json(value.data());
  }
  Future get_all_users()async{
    CollectionReference ref=FirebaseFirestore.instance.collection('users');
    var value = await ref.get();
    return value.docs;
  }
}