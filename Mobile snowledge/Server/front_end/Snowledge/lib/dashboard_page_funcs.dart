import 'dart:convert';
// import 'package:Snowledge/dashboard_page.dart'; // This line will be removed
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:snowledge/common/app_types.dart';

///

class OwnDetails extends StatefulWidget {
  const OwnDetails(
      {super.key,
      required this.username,
      required this.password,
      required this.userId,
      required this.loading,
      required this.updateCredentials});
  final String username;
  final String password;
  final int userId;
  final bool loading;
  final UpdateCredentials updateCredentials;

  @override
  State<OwnDetails> createState() => OwnDetailsState();
}

class OwnDetailsState extends State<OwnDetails> {
  final formKey = GlobalKey<FormState>();
  String editedUsername = "";
  String editedpassword1 = "";
  String editedpassword2 = "";

  @override
  void initState() {
    super.initState();
    editedUsername = widget.username;
  }

  Future submitClicked() async {
    Map modifiedUser = {
      "user_id": widget.userId,
      "username": editedUsername,
    };
    String hashedPassword =
        sha256.convert(utf8.encode(editedpassword1)).toString();
    if (editedpassword1 != "") {
      modifiedUser.addAll({"password": hashedPassword});
    }
    http.Response response = await http.put(
      Uri.parse('https://pallas.lumisovellus.fi/data/api/modify'),
      body: jsonEncode(modifiedUser),
      headers: {
        'Authorization': '${widget.username}:${widget.password}',
        'Content-Type': 'application/json',
      },
    );
    json.decode("[${response.body}]"); // result was unused
    widget.updateCredentials(editedUsername, hashedPassword);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Käyttäjänimi"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: 360,
              child: TextFormField(
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                initialValue: widget.username,
                onChanged: (value) {
                  setState(() {
                    editedUsername = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kenttä ei voi olla tyhjä';
                  }
                  return null;
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Vaihda salasana"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: 360,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "Syötä salasana"),
                        validator: (value) {
                          if (value != editedpassword2) {
                            return 'salasanat eivät täsmää';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            editedpassword1 = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "salasana uudelleen"),
                        validator: (value) {
                          if (value != editedpassword1) {
                            return 'salasanat eivät täsmää';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            editedpassword2 = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              width: 360,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (formKey.currentState!.validate()) {
                    submitClicked();
                  }
                },
                child: const Text('Tallenna'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// TABLE TO DISPLAY ALL USERS
Widget userTable(BuildContext context, List<dynamic> users,
    String loginUsername, String loginPassword, Function updateTable) {
  List<DataRow> createRows() {
    return users
        .map((user) => DataRow(
              cells: [
                DataCell(Text(user['username'].toString())),
                DataCell(Text(user['is_admin'] == 1 ? "Kyllä" : "Ei"))
              ],
              onSelectChanged: (isSelected) => {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => showPopup(context, user,
                        loginUsername, loginPassword, updateTable))
              },
            ))
        .toList();
  }

  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DataTable(
                showCheckboxColumn: false,
                dataRowColor:
                    WidgetStateProperty.resolveWith(getDataRowColor),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'käyttäjänimi',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Järjestelmävalvoja',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: createRows()),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TextButton(
          onPressed: () {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => showPopup(
                    context, {}, loginUsername, loginPassword, updateTable));
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('Lisää käyttäjä'),
        ),
      ),
    ],
  );
}

Color getDataRowColor(Set<WidgetState> states) {
  const Set<WidgetState> interactiveStates = <WidgetState>{
    WidgetState.pressed,
    WidgetState.hovered,
    WidgetState.focused,
  };
  if (states.any(interactiveStates.contains)) {
    return Colors.blue;
  }
  return Colors.transparent;
}

StatefulBuilder showPopup(BuildContext context, Map<dynamic, dynamic> user,
    String loginUsername, String loginPassword, Function updateTable) {
  final formKeyPopup = GlobalKey<FormState>();
  bool isnewUser = user.isEmpty;
  bool isChecked = isnewUser ? false : user["is_admin"] == 1;
  String username = isnewUser ? "" : user["username"];
  String password1 = "";
  String password2 = "";

  Future registerClicked() async {
    int admin = isChecked ? 1 : 0;
    String hashedPassword = sha256.convert(utf8.encode(password1)).toString();
    Map newUser = {
      "username": username,
      "password": hashedPassword,
      "is_admin": admin
    };
    http.Response response = await http.post(
      Uri.parse('https://pallas.lumisovellus.fi/data/api/register'),
      body: jsonEncode(newUser),
      headers: {
        'Authorization': '$loginUsername:$loginPassword',
        'Content-Type': 'application/json',
      },
    );
    json.decode("[${response.body}]"); // result was unused
    if (!context.mounted) return AlertDialog(title: Text("Error"));
    Navigator.pop(context);
    updateTable();
  }

  Future modifyClicked() async {
    int admin = isChecked ? 1 : 0;
    int userID = int.parse(user["user_id"].toString());

    Map modifiedUser = {
      "user_id": userID,
      "username": username,
      "is_admin": admin
    };
    if (password1 != "") {
      String hashedPassword = sha256.convert(utf8.encode(password1)).toString();
      modifiedUser.addAll({"password": hashedPassword});
    }
    http.Response response = await http.put(
      Uri.parse('https://pallas.lumisovellus.fi/data/api/modify'),
      body: jsonEncode(modifiedUser),
      headers: {
        'Authorization': '$loginUsername:$loginPassword',
        'Content-Type': 'application/json',
      },
    );
    json.decode("[${response.body}]"); // result was unused
    if (!context.mounted) return AlertDialog(title: Text("Error"));
    Navigator.pop(context);
    updateTable();
  }

  Future deleteClicked() async {
    int userID = int.parse(user["user_id"].toString());
    String url =
        'https://pallas.lumisovellus.fi/data/api/delete?user_id=$userID';
    await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': '$loginUsername:$loginPassword',
        'Content-Type': 'application/json;',
        "Access-Control-Allow-Origin": "*",
      },
    );
    if (!context.mounted) return;
    Navigator.pop(context);
    updateTable();
  }

  return StatefulBuilder(builder: (context, setState) {
    return AlertDialog(
        content: Form(
      key: formKeyPopup,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Käyttäjänimi"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
              initialValue: username,
              onChanged: (value) {
                setState(() {
                  username = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kenttä ei voi olla tyhjä';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(isnewUser ? "syötä salasana" : "Vaihda salasana"),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              width: 360,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "Syötä salasana"),
                        validator: (value) {
                          if (value != password2) {
                            return 'salasanat eivät täsmää';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password1 = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            labelText: "salasana uudelleen"),
                        validator: (value) {
                          if (value != password1) {
                            return 'salasanat eivät täsmää';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password2 = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Järjestelmävalvoja:"),
                Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                if (!isnewUser)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        deleteClicked();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Poista'),
                    ),
                  ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKeyPopup.currentState!.validate()) {
                        if (isnewUser) {
                          registerClicked();
                        } else {
                          modifyClicked();
                        }
                      }
                    },
                    child: Text(isnewUser ? "Lisää käyttäjä" : 'Tallenna'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  });
}
