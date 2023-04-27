import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/user_information_view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../state/appState.dart';

class RescueChat extends StatefulWidget {
  final BuildContext context;

  const RescueChat(this.context, {Key? key}) : super(key: key);
  @override
  _RescueChatState createState() => _RescueChatState();
}

class _RescueChatState extends State<RescueChat> {
  late String myPhoneNum;
  final _firestore = FirebaseFirestore.instance;
  final Stream<QuerySnapshot> _roomsStream =
      FirebaseFirestore.instance.collection('Rooms').snapshots();
  Map<String, dynamic>? selectedUser;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        myPhoneNum = prefs.getString('pNumber') ?? '';
      });
    });
    var appState = Provider.of<AppState>(context, listen: false);
    String roomId = appState.chatRoomId;

    final stream = FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomId)
        .collection('Messages')
        .orderBy('datetime', descending: true)
        .snapshots(includeMetadataChanges: false)
        .listen((event) async {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            // Notify the user of the new message if it's not from the sender
            if (change.doc.data()?['sent_by'] != myPhoneNum) {
              appState.setHasUnreadMessages = true;
            }
            break;
          case DocumentChangeType.modified:
            debugPrint("Modified message: ${change.doc.data()}");
            break;
          case DocumentChangeType.removed:
            debugPrint("Removed message: ${change.doc.data()}");
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    String roomId = appState.chatRoomId;

    // Calculate the width and height of the dialog based on the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final dialogWidth = screenWidth * 0.8;
    final dialogHeight = screenHeight * 0.8;
    return Center(
      child: StreamBuilder<QuerySnapshot>(
        stream: _roomsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Some loading/error states
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          // Access the room with the corresponding phone number of the request
          List<QueryDocumentSnapshot?> chatRoom = snapshot.data!.docs
              .where((element) => element.id == roomId)
              .toList();
          QueryDocumentSnapshot? chatRoomData =
              chatRoom.isNotEmpty ? chatRoom.first : null;

          // Data list of all users, will be used to display all users to chat with
          List<Map<String, dynamic>> users =
              List<Map<String, dynamic>>.from(chatRoomData?['users'] ?? []);

          bool phoneNumberFound = false;
          String color = 'grey';

          for (Map<String, dynamic> user in users) {
            if (user.containsKey(myPhoneNum)) {
              phoneNumberFound = true;
              break;
            }
          }

          if (!phoneNumberFound) {
            // If phone number of this helper is not already in the array, add them in with their color
            if (users.length == 1) {
              users.add({myPhoneNum: 'green'});
              color = 'green';
            } else if (users.length == 2) {
              users.add({myPhoneNum: 'blue'});
              color = 'blue';
            } else if (users.length == 3) {
              users.add({myPhoneNum: 'brown'});
              color = 'brown';
            }

            try {
              _firestore.collection('Rooms').doc(roomId).update({
                'users': FieldValue.arrayUnion([
                  {myPhoneNum: color}
                ]),
              });
            } catch (e) {
              print(e);
            }
          }

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
                          children: users.map((Map<String, dynamic> user) {
                            String phoneNum = user.keys.first;
                            String color = user.values.first;
                            return RescueChatWidgets.circleProfile(
                              roomId: roomId,
                              phoneNum: phoneNum,
                              backgroundColor: color,
                              appState: appState,
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    RescueChatWidgets.chatRoom(
                        roomId: roomId,
                        myPhoneNum: myPhoneNum,
                        users: users,
                        appState: appState),
                    // Button to close the chat dialog
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            appState.setHasUnreadMessages = false;
                          },
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
  // static Widget circleProfile({roomId, phoneNum, backgroundColor, appState}) {
  //   Color color;
  //   switch (backgroundColor) {
  //     case 'red':
  //       color = Colors.red.shade700;
  //       break;
  //     case 'green':
  //       color = Colors.green.shade700;
  //       break;
  //     case 'blue':
  //       color = Colors.blue.shade700;
  //       break;
  //     case 'brown':
  //       color = Colors.brown.shade700;
  //       break;
  //     // add more cases for other colors if needed
  //     default:
  //       color = Colors.grey; // default color if string doesn't match any cases
  //   }

  //   Map chatRoomUsersBattery = appState.chatRoomUsersBattery;

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     child: InkWell(
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           CircleAvatar(
  //             radius: 25,
  //             backgroundColor: color,
  //             child: const Icon(
  //               Icons.person,
  //               size: 40,
  //               color: Colors.white,
  //             ),
  //           ),
  //           SizedBox(
  //               width: 50,
  //               child: Center(
  //                   child: Text(
  //                 roomId == phoneNum ? 'Rescuee' : 'Helper',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   height: 1.5,
  //                   fontSize: 11,
  //                   color: Colors.black,
  //                 ),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               )))
  //         ],
  //       ),
  //     ),
  //   );
  // }
  static Widget circleProfile({
    roomId,
    phoneNum,
    backgroundColor,
    appState,
  }) {
    Color color;
    switch (backgroundColor) {
      case 'red':
        color = Colors.red.shade700;
        break;
      case 'green':
        color = Colors.green.shade700;
        break;
      case 'blue':
        color = Colors.blue.shade700;
        break;
      case 'brown':
        color = Colors.brown.shade700;
        break;
      // add more cases for other colors if needed
      default:
        color = Colors.grey; // default color if string doesn't match any cases
    }

    Map chatRoomUsersBattery = appState.chatRoomUsersBattery;

    bool isLowBattery = false;
    if (chatRoomUsersBattery.containsKey(roomId) &&
        chatRoomUsersBattery[roomId] == 'low') {
      isLowBattery = true;
    } else if (chatRoomUsersBattery.containsKey(phoneNum) &&
        chatRoomUsersBattery[phoneNum] == 'low') {
      isLowBattery = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: InkWell(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Center(
                    child: Text(
                      roomId == phoneNum ? 'Rescuee' : 'Helper',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 11,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            if (isLowBattery)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.battery_alert,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  static Widget chatRoom({roomId, myPhoneNum, users, appState}) {
    final firestore = FirebaseFirestore.instance;
    final _roomStream = firestore.collection('Rooms').snapshots();

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
                    // Access the room with the corresponding phone number of the request
                    List<QueryDocumentSnapshot?> allRoomsData = snapshot
                        .data!.docs
                        .where((element) => element.id == roomId)
                        .toList();

                    QueryDocumentSnapshot? roomData =
                        allRoomsData.isNotEmpty ? allRoomsData.first : null;

                    return roomData == null
                        ?
                        // If a room doesn't have any data, start the conversation
                        Center(
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
                                .collection('Messages')
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
                                                .toDate()),
                                            users,
                                            snap.data!.docs[i]['sent_by']);
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
                      .collection('Messages')
                      .add(data);
                }
              }
              controller.clear();
            }),
          )
        ],
      ),
    );
  }

  static Widget messagesCard(bool check, message, time, users, senderPhoneNum) {
    String colorString = 'grey';
    for (final user in users) {
      if (user.containsKey(senderPhoneNum)) {
        colorString = user[senderPhoneNum]!;
      }
    }
    Color color;
    switch (colorString) {
      case 'red':
        color = Colors.red.shade700;
        break;
      case 'green':
        color = Colors.green.shade700;
        break;
      case 'blue':
        color = Colors.blue.shade700;
        break;
      case 'brown':
        color = Colors.brown.shade700;
        break;
      // add more cases for other colors if needed
      default:
        color = Colors.grey; // default color if string doesn't match any cases
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (check) const Spacer(),
          if (!check)
            CircleAvatar(
              child: const Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: color,
              radius: 10,
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 250),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              child: Text(
                '$message\n\n$time',
                style: const TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color,
              ),
            ),
          ),
          if (check)
            CircleAvatar(
              child: Icon(
                Icons.person,
                size: 13,
                color: Colors.white,
              ),
              backgroundColor: color,
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
