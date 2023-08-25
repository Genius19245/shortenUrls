import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyBa6dBOwt9DCWwi9hf2NHCdx6xGg7y8nX4",
        authDomain: "shourya-s-french-app.firebaseapp.com",
        projectId: "shourya-s-french-app",
        storageBucket: "shourya-s-french-app.appspot.com",
        messagingSenderId: "58933452989",
        appId: "1:58933452989:web:43263d3f99c31b918517d4",
        measurementId: "G-QM25WMXEJ3"),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: UrlShortener(),
    );
  }
}

class UrlShortener extends StatefulWidget {
  const UrlShortener({Key? key}) : super(key: key);

  @override
  _UrlShortenerState createState() => _UrlShortenerState();
}

class _UrlShortenerState extends State<UrlShortener> {
  final ref = FirebaseFirestore.instance
      .collection('shortenurls')
      .doc('37oMnD3sKjaXYfi8CiEG');
  final TextEditingController _textController = TextEditingController();
  String? docId;
  bool? linkValidator;
  String? shortened =
      "Your shortened URL will appear here. You will need to copy it";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        title: const Text(
          "Shourya's URL Shortener",
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: ref.snapshots(),
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/128/4649/4649581.png',
                    height: MediaQuery.of(context).size.height / 2.75,
                    width: MediaQuery.of(context).size.width / 3.75,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        shortened!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                            ClipboardData(text: shortened ?? ""));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('link Copied to your clipboard !'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        labelStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.white60,
                          fontWeight: FontWeight.w200,
                        ),
                        hintText: 'Type your Url to shorten',
                        contentPadding:
                            const EdgeInsets.only(top: 13, left: 15),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            // FirebaseFirestore.instance
                            //     .collection('summarise')
                            //     .doc('kRtv8FQ0SVKENYrxa8cr')
                            //     .update({'summary': FieldValue.delete()});
                            await ref.update(
                              {'long': _textController.text},
                            );
                            // final doc = await ref
                            //     .add(DataModel(
                            //   text: _textController.text,
                            // ).toJson())
                            //     .then((doc) async {
                            //   setState(() {
                            //     docId = doc.id;
                            //   });
                            // });
                            Future.delayed(const Duration(seconds: 5),
                                () async {
                              setState(() {
                                shortened = snapshot.data!['shorten'];
                              });
                            });
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: InkWell(
                    onTap: () {
                      _textController.clear();
                      shortened =
                          "Your shortened URL will appear here. You will need to copy it";
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          color: Colors.blueAccent,
                        ),
                        width: MediaQuery.of(context).size.width / 5,
                        child: const Center(
                            child: Text(
                          'Clear',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
