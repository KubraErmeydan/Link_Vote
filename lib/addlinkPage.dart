import 'package:calisma/linkitem.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddLinkPage extends StatefulWidget {
  @override
  _AddLinkPageState createState() => _AddLinkPageState();
}

class _AddLinkPageState extends State<AddLinkPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _urlLinkController = TextEditingController();

  void _showSuccessToast() {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Link added successfully.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('LinkVOTE Challenge', style: TextStyle(color: Colors.white),) ,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
              children: [
          Row(
          children: [
    IconButton(
    icon: Icon(Icons.arrow_back,size: 34,),iconSize: 12,color: Colors.black,
    onPressed: () {
    Navigator.pop(context);
      },),
      Text('Return to List', style: TextStyle(fontSize:19, fontWeight: FontWeight.w500),)
      ],
    ),
    SizedBox(height: 60,),

    const Row(
    children: [
    Text('Add New Link', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),)
    ],),
     SizedBox(height: 50,),
     Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Link Name:'),
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      hintText: "e.g. Alphabet",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: 25),
                const Text('Link URL:'),
                TextField(
                  controller: _urlLinkController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      hintText: "e.g. http://abc.xyz",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    String name = _nameController.text;
                    String urlLink = _urlLinkController.text;
                    if (name.isNotEmpty && urlLink.isNotEmpty) {
                      Navigator.pop(
                        context,
                        LinkItem(name: name, urlLink: urlLink),
                      );
                      _showSuccessToast();
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('Please fill all the fields.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text("ADD", style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black,),
                ),
              ],
            ),
          ),]
      ),
        ),

      ),
    );
  }
}
