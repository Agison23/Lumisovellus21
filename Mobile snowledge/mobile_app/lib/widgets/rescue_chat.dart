import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../state/appState.dart';

class RescueChat extends StatefulWidget {
  @override
  _RescueChatState createState() => _RescueChatState();
}

class _RescueChatState extends State<RescueChat> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Users').snapshots();
  Map<String, dynamic>? selectedUser;

  @override
  Widget build(BuildContext context) {
    // Accessomg the global state to get our phone number
    var appState = Provider.of<AppState>(context, listen: false);
    // Calculate the width and height of the dialog based on the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth * 0.8;
    final dialogHeight = screenHeight * 0.8;
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Some loading/error states
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          // Data list of all users, will be used to display all users to chat with
          List<Map<String, dynamic>> userData = !snapshot.hasData
              ? []
              : snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return data;
                }).toList();

          return Container(
            width: dialogWidth,
            height: dialogHeight,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Material(
                color: Colors.white,
                child: Column(
                  children: [
                    // Display available users to chat with
                    SizedBox(
                      width: dialogWidth,
                      height: dialogHeight * 0.17,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: userData.map((Map<String, dynamic> data) {
                            if (data['phone'] == appState.myPhoneNum) {
                              return Container();
                            }
                            return RescueChatWidgets.circleProfile(
                              onTap: () {
                                setState(() {
                                  selectedUser = data;
                                });
                              },
                              name: data['name'],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // Attempt to display the chat room with the selected user if selected one, or prompt to select a user to start talking
                    selectedUser != null
                        ? RescueChatWidgets.chatRoom(
                            phoneNumToChatWith: selectedUser?['phone'],
                            myPhoneNum: appState.myPhoneNum,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(10),
                            child: SizedBox(
                              width: dialogWidth,
                              height: dialogHeight * 0.7,
                              child: Center(
                                child: Text(
                                  'Select a user to start talking',
                                  style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)
                                      .copyWith(color: Colors.indigo.shade400),
                                ),
                              ),
                            ),
                          ),
                    // Button to close the chat dialog
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RescueChatWidgets {
  static Widget circleProfile({onTap, name}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(
                width: 50,
                child: Center(
                    child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    fontSize: 11,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )))
          ],
        ),
      ),
    );
  }

  static Widget chatRoom({
    phoneNumToChatWith,
    myPhoneNum,
  }) {
    final firestore = FirebaseFirestore.instance;
    final _roomStream = firestore.collection('Rooms').snapshots();
    var roomId;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // The chat window
          SizedBox(
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: StreamBuilder(
                stream: _roomStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    // All rooms that contains my phone number and the phone number of the person to chat with
                    List<QueryDocumentSnapshot?> allRoomsData = snapshot
                        .data!.docs
                        .where((element) =>
                            element['users'].contains(myPhoneNum) &&
                            element['users'].contains(phoneNumToChatWith))
                        .toList();
                    print('Rooms data is: $allRoomsData');
                    QueryDocumentSnapshot? roomData =
                        allRoomsData.isNotEmpty ? allRoomsData.first : null;
                    if (roomData != null) {
                      roomId = roomData.id;
                      print('Room ID is: $roomId');
                    }
                    return roomData == null
                        ? Center(
                            child: Text(
                              'Start a new conversation',
                              style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)
                                  .copyWith(color: Colors.indigo.shade400),
                            ),
                          )
                        : StreamBuilder(
                            stream: roomData.reference
                                .collection('messages')
                                .orderBy('datetime', descending: true)
                                .snapshots(),
                            builder:
                                (context, AsyncSnapshot<QuerySnapshot> snap) {
                              return !snap.hasData
                                  ? Container()
                                  : ListView.builder(
                                      itemCount: snap.data!.docs.length,
                                      reverse: true,
                                      itemBuilder: (context, i) {
                                        return RescueChatWidgets.messagesCard(
                                            snap.data!.docs[i]['sent_by'] ==
                                                myPhoneNum,
                                            snap.data!.docs[i]['message'],
                                            DateFormat('hh:mm a').format(snap
                                                .data!.docs[i]['datetime']
                                                .toDate()));
                                      },
                                    );
                            },
                          );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.indigo,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // Message field
          Container(
            color: Colors.white,
            child: RescueChatWidgets.messageField(onSubmit: (controller) {
              if (controller.text.toString() != '') {
                if (roomId != null) {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': myPhoneNum,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').doc(roomId).update({
                    'last_message_time': DateTime.now(),
                    'last_message': controller.text,
                  });
                  firestore
                      .collection('Rooms')
                      .doc(roomId)
                      .collection('messages')
                      .add(data);
                } else {
                  Map<String, dynamic> data = {
                    'message': controller.text.trim(),
                    'sent_by': myPhoneNum,
                    'datetime': DateTime.now(),
                  };
                  firestore.collection('Rooms').add({
                    'users': [
                      phoneNumToChatWith,
                      myPhoneNum,
                    ],
                    'last_message': controller.text,
                    'last_message_time': DateTime.now(),
                  }).then((value) async {
                    value.collection('messages').add(data);
                  });
                }
              }
              controller.clear();
            }),
          )
        ],
      ),
    );
  }

  static Widget messagesCard(bool check, message, time) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              child: Text(
                '$message\n\n$time',
                style: TextStyle(color: check ? Colors.white : Colors.black),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: check ? Colors.indigo.shade300 : Colors.grey.shade300,
              ),
            ),
          ),
          if (check)
            const CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey,
              radius: 10,
            ),
          if (!check) const Spacer(),
        ],
      ),
    );
  }

  static messageField({required onSubmit}) {
    final con = TextEditingController();

    return Container(
      margin: const EdgeInsets.all(5),
      child: TextField(
          controller: con,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Enter Message',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            suffixIcon: IconButton(
                onPressed: () {
                  onSubmit(con);
                },
                icon: const Icon(Icons.send)),
          )),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(10)),
    );
  }
}
