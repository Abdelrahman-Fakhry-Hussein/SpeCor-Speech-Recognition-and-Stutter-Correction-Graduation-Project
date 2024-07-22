import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:specor/message_model.dart';
import 'package:specor/user_model.dart';
import 'specor_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;

class Chat_1 extends StatefulWidget {
  @override
  final SpeCor_model chat_data;
  Chat_1(this.chat_data);
  State<Chat_1> createState() => _Chat_1State(chat_data);
}

class _Chat_1State extends State<Chat_1> {
  TextEditingController text = TextEditingController();
  SpeCor_model chat_data;
  List chat = [];
  User_model? x;
  final record = AudioRecorder();
  bool is_record = false;
  String path = '';
  String url = '';
  bool is_uploaded = false;
  bool is_player = false;
  bool isLoading = false;
  bool isPause = false;
  Duration duration = new Duration();
  Duration position = new Duration();
  late AudioPlayer audioPlayer;
  String auth = FirebaseAuth.instance.currentUser!.uid;
  int? currentlyPlayingIndex;

  _Chat_1State(this.chat_data);

  @override
  void initState() {
    text.addListener(() {
      setState(() {});
    });
    get_x_user();
    Stream_chat();
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
  void _changeSeek(double value) {
    setState(() {
      audioPlayer.seek(new Duration(seconds: value.toInt()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        elevation: 0,
        title: Row(
          children: [
            x!.image == ""
                ? CircleAvatar(
              backgroundImage: AssetImage(
                "assets/avatar.png",
              ),
            )
                : CircleAvatar(backgroundImage: NetworkImage(x!.image)),
            SizedBox(
              width: 10.w,
            ),
            Text(x!.name ?? ''),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/download.jpg",
                ),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chat.length,
                reverse: true,
                itemBuilder: (_, index) => Column(
                  children: [
                    message_item(
                        message_model.from_json(chat[chat.length - (index + 1)]),
                        index),

                  ],
                ),
              ),
            ),
            isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SizedBox.shrink(),
            Container(
              padding: EdgeInsets.all(15),
              color: Colors.black87,
              height: 80.h,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: text,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  text.text.isEmpty
                      ? CircleAvatar(
                    backgroundColor:
                    is_uploaded == false ? Colors.blue : Colors.grey,
                    child: IconButton(
                      onPressed: is_uploaded == false
                          ? () {
                        if (!is_record) {
                          start_record();
                        } else {
                          stop_record();
                        }
                      }
                          : () {},
                      icon: is_record == true && is_uploaded == false
                          ? Icon(Icons.stop)
                          : is_record == false && is_uploaded == false
                          ? Icon(Icons.mic)
                          : Icon(
                        Icons.upload,
                        color: Colors.black54,
                      ),
                    ),
                  )
                      : IconButton(
                      onPressed: () async {
                        await add_message("text");
                        setState(() {
                          text.text = '';
                        });
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void get_x_user() {
    setState(() {
      x = chat_data.users.firstWhere((element) => element.id != auth);
    });
  }

  void Stream_chat() async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chat_data.id)
        .snapshots()
        .listen((event) {
      setState(() {
        chat = SpeCor_model.from_json(event.data()!).chat.toList();
      });
    });
  }

  Future<void> add_message(String kind, {String? audioUrl, String? model_message}) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('chats');
    await ref.doc(chat_data.id).update({
      'chat': FieldValue.arrayUnion([
        message_model(
            id: 'id',
            text: model_message == null ? text.text : model_message,
            sender_id: auth,
            time: Timestamp.now(),
            show_time: false,
            audio: audioUrl ?? url,
            kind: kind)
            .to_json()
      ])
    });
  }


  Widget message_item(message_model message, int indexx) {
    bool isCurrentlyPlaying = currentlyPlayingIndex == indexx;
    int index = chat.indexWhere((element) => element['time'] == message.time);

    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          chat[index]['show_time'] = !chat[index]['show_time'];
        });
      },
      child: Column(
        children: [
          message.kind == 'text'
              ? BubbleSpecialThree(
            isSender: message.sender_id == auth,
            text: message.text,
            color: message.sender_id == auth
                ? Color(0xff4f81bd)
                : Colors.green,
            tail: true,
            seen: message.sender_id == auth ? true : false,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          )
              :message.sender_id == auth? Row(
            children: [
              SizedBox(
                width: 35.w,
              ),
              PopupMenuButton<String>(
                child: Image.asset("assets/checkmic.png",height: 35.h,width: 35.w,),
                onSelected: (String value) {
                  print(value);
                  if (value == 'correct to text') {
                    setState(() {
                      forwardMessage(message);
                    });
                  } else if (value == 'correct to speech') {
                    setState(() {
                      predictspeech(message);
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Correct to text', 'Correct to speech'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice.toLowerCase(),
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
              Expanded(
                child: BubbleNormalAudio(
                  onSeekChanged: _changeSeek,
                  isPlaying: isCurrentlyPlaying && is_player,
                  isLoading: isLoading,
                  isPause: isPause,
                  duration: duration.inSeconds.toDouble(),
                  position: position.inSeconds.toDouble(),
                  isSender: message.sender_id == auth,
                  onPlayPauseButtonClick: () {
                    if (isCurrentlyPlaying) {
                      stop();
                    } else {
                      play(message.audio);
                      setState(() {
                        currentlyPlayingIndex = indexx;
                      });
                    }
                  },
                ),
              ),
            ],
          ):
          Row(
            children: [

              Expanded(
                child: BubbleNormalAudio(
                  onSeekChanged: _changeSeek,
                  isPlaying: isCurrentlyPlaying && is_player,
                  isLoading: isLoading,
                  isPause: isPause,
                  duration: duration.inSeconds.toDouble(),
                  position: position.inSeconds.toDouble(),
                  isSender: message.sender_id == auth,
                  onPlayPauseButtonClick: () {
                    if (isCurrentlyPlaying) {
                      stop();
                    } else {
                      play(message.audio);
                      setState(() {
                        currentlyPlayingIndex = indexx;
                      });
                    }
                  },
                ),
              ),

              PopupMenuButton<String>(
                child: Image.asset("assets/checkmic.png",height: 35.h,width: 35.w,),
                onSelected: (String value) {
                  print(value);
                  if (value == 'correct to text') {
                    setState(() {
                      forwardMessage(message);
                    });
                  } else if (value == 'correct to speech') {
                    setState(() {
                      predictspeech(message);
                    });
                  }
                },
                itemBuilder: (BuildContext context) {
                  return {'Correct to text', 'Correct to speech'}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice.toLowerCase(),
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
              SizedBox(
                width: 35.w,
              ),
            ],
          ),
          message.show_time
              ? Text(
            message.time.toDate().toString(),
            style: TextStyle(color: Colors.white),
          )
              : SizedBox(),
        ],
      ),
    );
  }

  void start_record() async {
    final location = await getApplicationDocumentsDirectory();
    String name = Uuid().v1();
    if (await record.hasPermission()) {
      await record.start(RecordConfig(), path: location.path + name + '.m4a');
      setState(() {
        is_record = true;
      });
    }
    print("start record");
  }
  void _playAudio(url) async {
    await audioPlayer.play(UrlSource(url));
    if (isPause) {
      await audioPlayer.resume();
      setState(() {
        is_player = true;
        isPause = false;
      });
    } else if (is_player) {
      await audioPlayer.pause();
      setState(() {
        is_player = false;
        isPause = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
      await audioPlayer.play(UrlSource(url));
      setState(() {
        is_player = true;
      });
    }

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
        isLoading = false;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        is_player = false;
        duration = new Duration();
        position = new Duration();
      });
    });
  }
  void stop_record() async {
    String? final_path = await record.stop();
    setState(() {
      path = final_path!;
      is_record = false;
    });
    print(final_path);
    print('stop record');
    upload();
  }

  void upload() async {
    setState(() {
      is_uploaded = true;
    });
    String name = basename(path);
    final ref = FirebaseStorage.instance.ref("voice/" + name);
    await ref.putFile(File(path));
    String download_url = await ref.getDownloadURL();
    setState(() {
      url = download_url;
      is_uploaded = false;
    });
print(path);
print(url);
    print("uploaded");
    add_message('audio');
  }





  Future<void> play(url) async {
    await audioPlayer.play(UrlSource(url));
    setState(() {
      is_player = true;
    });
  }

  stop() async {
    await audioPlayer.stop();
    setState(() {
      is_player = false;
      currentlyPlayingIndex = null;
    });
  }

  forwardMessage(message_model message) {
    // Implement the logic to forward the message to another chat.
    // For simplicity, let's assume we're forwarding to a chat with a hardcoded chat ID.
    String targetChatId = "target_chat_id";
    print(message.audio);
   // add_message('audio', audioUrl: message.audio);
    predictText(message.audio);
  }







  Future<void> predictText(String audioFileUrl) async {
    setState(() {
      isLoading = true; // Set loading state to true before making API call
    });


    final url = Uri.parse('http://192.168.1.4:8000/predict');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({'url': audioFileUrl});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          add_message('text', model_message: data['transcription']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to get transcription');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> uploadAudio() async {
    try {
      // Load the audio file from the assets
      final byteData = await rootBundle.load("assets/speech.mp3");

      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/speech.mp3');

      // Write the byte data to the file
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Create a reference to the location you want to upload to in Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child('speech.mp3');

      // Upload the file
      final uploadTask = storageRef.putFile(tempFile);

      // Optionally, monitor the upload progress
      uploadTask.snapshotEvents.listen((event) {
        print('Task state: ${event.state}');
        print('Progress: ${(event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) * 100} %');
      });

      // Wait until the file is uploaded
      await uploadTask.whenComplete(() => print('Upload complete'));

      // Get the download URL of the uploaded file
      final downloadURL = await storageRef.getDownloadURL();
      setState(() {
        url = downloadURL;
      });

      print("uploaded");
      add_message('audio');
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error: $e');
    }
  }



  Future<void> predictspeech(message_model message) async {
    setState(() {
      isLoading = true; // Set loading state to true before making API call
    });

    final url = Uri.parse('http://192.168.1.4:8000/predict/audio');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({'url': message.audio});

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final data = await jsonDecode(response.body);
        setState(() {
          print(data["speech_file"]);
          uploadAudio();
          isLoading = false; // Set loading state to false after successful response
        });
      } else {
        throw Exception('Failed to get transcription');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Set loading state to false on error
      });
    }
  }


}
