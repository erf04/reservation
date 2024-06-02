// import 'package:application/design/user.dart';
// import 'package:application/main.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:image/image.dart' as img;
// import 'dart:typed_data';
// import 'dart:io';

// import 'package:flutter/services.dart' show rootBundle;
// import 'package:flutter/services.dart';
// import 'package:flutter_avif/flutter_avif.dart';
// import 'package:application/gen/assets.gen.dart';
// import 'package:flutter/material.dart';

// class Profile extends StatefulWidget {
//   const Profile({super.key});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
  
  
//   Future<User> getProfile() async{
//     final response = HttpClient.instance
//   } 
  
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           title: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               IconButton(
//                   onPressed: () {
//                     //Navigator.pushReplacement(context, MyHomePage(title: ''));
//                   },
//                   icon: const Icon(
//                     CupertinoIcons.back,
//                     size: 40,
//                     color: Colors.orange,
//                   )),
//               Text(
//                 "Profile",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyMedium!
//                     .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
//               ),
//               IconButton(
//                   onPressed: () {
//                     //Navigator.pushReplacement(context, MyHomePage(title: ''));
//                   },
//                   icon: const Icon(
//                     CupertinoIcons.mail,
//                     size: 40,
//                     color: Colors.orange,
//                   )),
//             ],
//           ),
//           backgroundColor: Colors.white,
//         ),
//         body: FutureBuilder(
//           future: void
//           child: SafeArea(
//               child: Stack(
//             fit: StackFit.expand,
//             children: [
//               Container(
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('assets/images.jpg'),
//                     fit: BoxFit
//                         .cover, // This ensures the image covers the entire background
//                   ),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.fromLTRB(
//                       0, 0, 0, MediaQuery.of(context).size.height * 0.7),
//                   child: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           boxShadow: const [BoxShadow(blurRadius: 2)],
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(24),
//                               bottomRight: Radius.circular(24))),
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.35),
//                 ),
//               ),
//               Center(
//                 child: CircleAvatar(
//                   backgroundColor: Colors.transparent,
//                   radius: 80,
//                   child: ClipOval(
//                     child: Container(
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             'http://10.0.2.2:8000/api${snapshot.data?.image}',
//                         placeholder: (context, url) => Center(
//                             child: CircularProgressIndicator()),
//                         errorWidget: (context, url, error) =>
//                             Center(child: Icon(Icons.error)),
//                         fit: BoxFit.cover,
//                         width: 160,
//                         height: 160,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           )),
//         ));
//   }
// }
