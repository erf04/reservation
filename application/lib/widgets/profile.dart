import 'package:application/design/user.dart';
import 'package:application/gen/assets.gen.dart';
import 'package:application/main.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/loginSignUp_state.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<User?> getProfile() async {
    VerifyToken? myVerify = await TokenManager.verifyAccess(context);
    if (myVerify == VerifyToken.verified) {
      String? myAccess = await TokenManager.getAccessToken();
      print(myAccess);
      final response = await HttpClient.instance.get("api/profile/",
          options: Options(headers: {"Authorization": "JWT $myAccess"}));
      User myUser = User(
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
                  onPressed: () {
                    //Navigator.pushReplacement(context, MyHomePage(title: ''));
                  },
                  icon: const Icon(
                    CupertinoIcons.back,
                    size: 40,
                    color: Colors.orange,
                  )),
              Text(
                "Profile",
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
                    color: Colors.orange,
                  )),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder<User?>(
            future: getProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: SizedBox(
                      height: 10, child: Text("Something went wrong!")),
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
                        image: DecorationImage(
                          image: AssetImage('assets/images.jpg'),
                          fit: BoxFit
                              .cover, // This ensures the image covers the entire background
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, 0, 0, MediaQuery.of(context).size.height * 0.7),
                        child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [BoxShadow(blurRadius: 2)],
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24))),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.35),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 0, 0, MediaQuery.of(context).size.height * 0.4),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
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
                              height: 160,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ));
              } else {
                return const Center(
                  child: SizedBox(
                      height: 10, child: Text("Something went wrong!")),
                );
              }
            }));
  }
}
