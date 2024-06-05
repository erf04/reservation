import 'package:application/design/user.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  
  Future<User?> getProfileForMainPage() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      print(myAccess);
      final response = await HttpClient.instance.get("api/profile/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      User myUser = User(
          isShiftManager: response.data["is_shift_manager"],
          isSuperVisor: response.data["is_supervisor"],
          id: response.data["id"],
          userName: response.data["username"],
          profilePhoto: response.data["profile"]);
      return myUser;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      foregroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.back,
                size: 40,
                color: Color.fromARGB(255, 2, 16, 43),
              )),
          Text(
            'Main Page',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                //Navigator.pushReplacement(context, MyHomePage(title: ''));
              },
              icon: const Icon(
                CupertinoIcons.mail,
                size: 40,
                color: Color.fromARGB(255, 2, 16, 43),
              )),
        ],
      ),
      backgroundColor: Colors.white,
    ),
      body: SafeArea(
        child: FutureBuilder<User?>(
          future: getProfileForMainPage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: SizedBox(height: 10, child: Text("Something went wrong!")),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return SafeArea(
                  child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      //color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage('assets/pintrest2.jpg'),
                        fit: BoxFit
                            .cover, // This ensures the image covers the entire background
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height * 0.7),
                      child: Container(
                          decoration: const BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage('assets/pintrest2.jpg'),
                              //   fit: BoxFit
                              //       .cover, // This ensures the image covers the entire background
                              // ),
                              color: Colors.white,
                              boxShadow: const [BoxShadow(blurRadius: 2)],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24))),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.35),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.deepOrange,
                            radius: 80,
                            child: ClipOval(
                              child: Container(
                                child: CachedNetworkImage(
                                    imageUrl:
                                        'http://10.0.2.2:8000${snapshot.data?.profilePhoto}',
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Center(child: Icon(Icons.error)),
                                    fit: BoxFit.cover,
                                    width: 160,
                                    height: 160),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Column(

                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 2/5,
                            height: MediaQuery.of(context).size.height * 2/3,
                            child: ,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ));
            } else {
              return const Center(
                child: SizedBox(height: 10, child: Text("Something went wrong!")),
              );
            }
          }),
      )
    );
  }
}
