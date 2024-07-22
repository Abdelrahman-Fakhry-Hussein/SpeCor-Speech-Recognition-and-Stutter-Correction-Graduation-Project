import 'package:cloud_firestore/cloud_firestore.dart';
class message_model{
  String id;
  String text;
  String sender_id;
  Timestamp time;
  bool show_time;
  String audio;
  String kind;
  message_model({required this.id,required this.text,required this.sender_id,required this.time,required this.show_time,required this.audio,required this.kind});
  message_model.from_json(map):this(
    id: map['id'],
    text:map['text'],
    sender_id: map['sender_id'],
    time: map['time'],
    show_time: map['show_time'],
    audio: map['audio'],
    kind: map['kind']
  );
  to_json(){
    return {
      'id':id,
      'text':text,
      'sender_id':sender_id,
      'time':time,
      'audio':audio,
      'kind':kind,
    'show_time':show_time};
    }
  }
