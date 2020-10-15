import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool uploading = false;
  String parsedtext = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: 30.0,
              ),
              alignment: Alignment.center,
              child: Text(
                "OCR App",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            GestureDetector(
              onTap: () => parseTheText(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.deepPurple,
                ),
                child: Center(
                  child: Text(
                    "Upload Image",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            uploading == false ? Container() : CircularProgressIndicator(),
            SizedBox(
              height: 70.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    "Parsed Text is",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    parsedtext,
                    style: GoogleFonts.montserrat(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  parseTheText() async {
    final imageFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 670, maxHeight: 970);

    setState(() {
      uploading = true;
    });
    var bytes = Io.File(imageFile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
    var header = {"apiKey": "7dcbcb8df388957"};
    var post = await http.post(url, body: payload, headers: header);

    var result = jsonDecode(post.body);
    setState(() {
      uploading = false;
      parsedtext = result['ParsedResults'][0]['ParsedText'];
    });

  }
}
