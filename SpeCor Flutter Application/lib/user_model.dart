 class User_model{
  String id,name,image,email,pass;
  User_model({required this.name,required this.image,required this.email,required this.pass,required this.id});
  User_model.from_json(map):this(
    id:map['uid'],
    name: map['name'],
    email:map['email'],
    pass: map['pass'],
    image:map['image']
  );
  to_json(){
    return {
    'uid':id,
      'name':name,
      'email':email,
      'pass':pass,
      'image':image
    };
  }
 }