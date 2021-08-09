import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'localdb/db.dart';
import 'localdb/model.dart';

class Popscreen extends StatefulWidget {
  @override
  _PopscreenState createState() => _PopscreenState();
}

class _PopscreenState extends State<Popscreen> {
  final myController = TextEditingController();

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('add data'),
        ),
        body: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Enter your text'),
              keyboardType: TextInputType.url,
              controller: myController,
            ),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        child: Text(
                          '  ADD  TEXT  ',
                        ),
                        autofocus: true,
                        onPressed: () {
                          Db().adddata(Data(myController.text));
                          Navigator.pop(context);
                        }))),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                        child: Text(
                          '  PASTE  TEXT  ',
                        ),
                        autofocus: true,
                        onPressed: () {
                          FlutterClipboard.paste().then((value) {
                            // Do what ever you want with the value.
                            setState(() {
                              myController.text = myController.text + value;
                            });
                          });
                        }))),
          ],
        ));
  }
}
