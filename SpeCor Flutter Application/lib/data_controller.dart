import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:specor/user_model.dart';

import 'firebase/get.dart';
class Data_controller extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  User_model Current_User = User_model(name: 'name', image: 'image', email: 'email', pass: 'pass', id: 'uid');
  List chats = [];
  List users = [];

  Data_controller() {
    print(auth.currentUser!.email);
    get_user(auth.currentUser!.uid);
    get_all_users();
  }

  get_user(id) async {
    await Firebase_get().get_current_user(id).then((value) {
      Current_User = value;
      update();
    });
  }

  get_all_users() async {
    Firebase_get().get_all_users().then((value) {
      for (var i in value) {
        users.add(User_model.from_json(i.data()));
      }
      // Remove current user if exists
      users.removeWhere((user) => user.id == auth.currentUser!.uid);
      update();
    });
  }
}
