import 'package:specor/user_model.dart';

class SpeCor_model{
  String id;
  List<User_model> users=[];
  List users_id=[];
  List chat=[];

  SpeCor_model({required this.id,required this.users,required this.chat,required this.users_id});
  SpeCor_model.from_json(map):this(
      id:map['id'],
      users:map["users"].map<User_model>((e)=>User_model.from_json(e)).toList(),
      chat: map['chat'],
      users_id: map[ "users_id"]);


  // SpeCor_model.from_json(map):this(
  //   id:map['id'],
  //   users:map["users"].map<User_model>((e)=>User_model.from_json(e)).toList(),
  // chat: map['chat'],
  // users_id: map[ "users_id"]);
  to_json(){
    return{
      'id':id,
      'users':users.map((e) => e.to_json()).toList(),
      'chat':chat,
      'users_id':users_id
    };
  }


}