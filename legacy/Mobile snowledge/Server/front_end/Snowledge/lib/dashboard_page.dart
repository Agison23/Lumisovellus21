import 'dart:convert';
import 'package:snowledge/main_page.dart';
import 'package:http/http.dart';
import 'package:snowledge/dashboard_page_funcs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:snowledge/common/app_types.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage(
      {super.key,
      required this.username,
      required this.password,
      required this.updateMainPageCredentials});
  final String username;
  final String password;
  final UpdateCredentials updateMainPageCredentials;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 1;
  bool loading = false;
  int userId = -1;
  List<dynamic> users = [];
  dynamic thisUser;
  bool isAdmin = false;
  String loginUsername = "";
  String loginPassword = "";

  Future<void> updateData() async {
    setState(() {
      loading = true;
    });

    if (userId == -1) {
      Response response = await get(
        Uri.parse('https://pallas.lumisovellus.fi/data/api/login'),
        headers: {
          'Authorization': '$loginUsername:$loginPassword',
          'Content-Type': 'application/json',
        },
      );
      List<dynamic> result = json.decode("[${response.body}]");
      //print('$loginUsername:$loginPassword');
      //print(result);
      setState(() {
        userId = result[0]["user_id"];
      });
    }

    Response response = await get(
      Uri.parse('https://pallas.lumisovellus.fi/data/api/users'),
      headers: {
        'Authorization': '$loginUsername:$loginPassword',
        'Content-Type': 'application/json',
      },
    );
    //print(json.decode(response.body));
    List<dynamic> usersData = json.decode(response.body);

    for (var i = 0; i < usersData.length; i++) {
      if (usersData[i]["user_id"] == userId) {
        isAdmin = usersData[i]["is_admin"] == 1;
      }
    }
    usersData = usersData.where((user) => user["user_id"] != userId).toList();
    setState(() {
      users = usersData;
      loading = false;
    });
  }

  void setLoad(bool value) {
    setState(() {
      loading = value;
    });
  }

  void updateCredentials(String updatedUsername, String updatedPassword) {
    setState(() {
      loginUsername = updatedUsername;
      loginPassword = updatedPassword;
    });

    widget.updateMainPageCredentials(updatedUsername, updatedPassword);
    //print(updatedUsername);
    //print(updatedPassword);
  }

  @override
  void initState() {
    loginUsername = widget.username;
    loginPassword = widget.password;
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Tooltip(
                    message: "Omat tiedot", child: Icon(Icons.person_outline)),
                selectedIcon:
                    Tooltip(message: "Omat tiedot", child: Icon(Icons.person)),
                label: Text(""),
              ),
              NavigationRailDestination(
                icon: Tooltip(
                    message: "Käyttäjähallinta",
                    child: Icon(Icons.manage_accounts_outlined)),
                selectedIcon: Tooltip(
                    message: "Käyttäjähallinta",
                    child: Icon(Icons.manage_accounts)),
                label: Text(''),
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: pageBuilder(loading, updateData, updateCredentials),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Karttanäkymä',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Mainpage(
                            username: loginUsername, password: loginPassword),
                      ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pageBuilder(
      bool loading, Function updateTable, UpdateCredentials updateCredentials) {
    if (loading) {
      return const SpinKitCircle(
        color: Colors.blue,
        size: 80.0,
      );
    }

    switch (selectedIndex) {
      case 0:
        return OwnDetails(
            username: loginUsername,
            password: loginPassword,
            userId: userId,
            loading: loading,
            updateCredentials: updateCredentials);
      case 1:
        if (isAdmin == false) {
          return const Text("Et ole järjestelmävalvoja");
        }
        return userTable(
            context, users, loginUsername, loginPassword, updateTable);
      default:
        return const Text("error");
    }
  }
}

BoxDecoration navBoxDecoration() {
  return const BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Colors.grey,
        width: 0.8,
      ),
    ),
  );
}
