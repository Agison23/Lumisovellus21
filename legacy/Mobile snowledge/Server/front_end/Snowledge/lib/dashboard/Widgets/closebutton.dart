import 'package:snowledge/main_page.dart';
import 'package:flutter/material.dart';

Padding closeButton(BuildContext context, String username, String password) {
  return Padding(
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
                builder: (context) =>
                    Mainpage(username: username, password: password),
              ));
        },
      ),
    ),
  );
}
