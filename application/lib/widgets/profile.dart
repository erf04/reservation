import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:application/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(onPressed: Navigotar.pop, icon: icon),
            Text("Profile", style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
            child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(_backgroundImage!),
              fit: BoxFit.cover, // This ensures the image covers the entire background
            ),
          ),
        ),])
    ));
  }
}
