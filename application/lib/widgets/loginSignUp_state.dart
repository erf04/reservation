import 'package:application/gen/assets.gen.dart';
import 'package:application/main.dart';
import 'package:application/repository/HttpClient.dart';
import 'package:application/repository/tokenManager.dart';
import 'package:application/widgets/MainPage.dart';
import 'package:application/widgets/SoftenPageTransition.dart';
import 'package:flutter/material.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  bool loginError = false;
  bool signUpError = false;
  bool isInError = false;
  bool isInSignUp = false;
  bool obscurity = true;
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
  TextEditingController myController3 = TextEditingController();

  static Future<bool> getAuthLogin(
      String myUser, String myPass, context) async {
    final response = await HttpClient.instance.post('auth/jwt/create/',
        data: {'username': myUser, 'password': myPass});
    if (response.statusCode == 200) {
      TokenManager.saveTokens(
          response.data["access"], response.data["refresh"]);
      FadePageRoute.navigateToNextPage(context, MainPage());
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getAuthSignUp(
      String myUser, String myPass, BuildContext context) async {
    final response;
    response = await HttpClient.instance
        .post('auth/users/', data: {'username': myUser, 'password': myPass});
    if (response.statusCode == 201) {
      _LoginSignUpState.getAuthLogin(myUser, myPass, context);
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/pintrest2.jpg'),
              fit: BoxFit
                  .cover, // This ensures the image covers the entire background
            ),
          ),
        ),
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [BoxShadow(blurRadius: 2)],
                borderRadius: BorderRadius.circular(12)),
            width: MediaQuery.of(context).size.width * 0.8,
            height: isInSignUp
                ? MediaQuery.of(context).size.height * 0.56
                : MediaQuery.of(context).size.height * 0.56,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: isInSignUp
                  ? signUpError
                      ? getSignUpError(context)
                      : getSignUp(context)
                  : loginError
                      ? getLoginError(context)
                      : getLogin(context),
            ),
          ),
        )
      ],
    )));
  }

  Column getLogin(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = false;
                });
              },
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.blueGrey : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = true;
                });
              },
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.black : Colors.blueGrey),
              ),
            ),
          ],
        ),
        Column(children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: myController1,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                label: Text('username')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController2,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey))),
                label: const Text('Password')),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No account yet?"),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isInSignUp = true;
                    });
                  },
                  child: Text(
                    "register now",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.blueGrey),
                  ))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {
                getAuthLogin(myController1.text, myController2.text, context);
                setState(() {
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    loginError = true;
                  });
                });
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text("Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)))
        ])
      ],
    );
  }

  Column getSignUp(BuildContext context) {
    bool notEqualError = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = false;
                });
              },
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.blueGrey : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = true;
                });
              },
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.black : Colors.blueGrey),
              ),
            ),
          ],
        ),
        Column(children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: myController1,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                label: Text('username')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController2,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey))),
                label: const Text('Password')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController3,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey))),
                label: const Text('Confirm Password')),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                if (myController2.text == myController3.text) {
                  _LoginSignUpState.getAuthSignUp(
                      myController1.text, myController2.text, context);
                } else {
                  setState(() {
                    signUpError = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text("Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)))
        ])
      ],
    );
  }

  Column getLoginError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = false;
                });
              },
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.blueGrey : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = true;
                });
              },
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.black : Colors.blueGrey),
              ),
            ),
          ],
        ),
        Column(children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: myController1,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                label: Text('username')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController2,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey))),
                label: const Text('Password')),
          ),
          Text("Wrong information! try again",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red)),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No account yet?"),
              const SizedBox(
                width: 8,
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      isInSignUp = true;
                    });
                  },
                  child: Text(
                    "register now",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.blueGrey),
                  ))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {
                getAuthLogin(myController1.text, myController2.text, context);
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text("Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)))
        ])
      ],
    );
  }

  Column getSignUpError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = false;
                });
              },
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.blueGrey : Colors.black),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  this.isInSignUp = true;
                });
              },
              child: Text(
                "Sign up",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    color: isInSignUp ? Colors.black : Colors.blueGrey),
              ),
            ),
          ],
        ),
        Column(children: [
          const SizedBox(
            height: 40,
          ),
          TextField(
            controller: myController1,
            enableSuggestions: true,
            autocorrect: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                label: Text('username')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController2,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue))),
                label: const Text('Password')),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: myController3,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: obscurity,
            decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                fillColor: Colors.black12,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
                filled: true,
                suffixIcon: TextButton(
                    onPressed: () {
                      setState(() {
                        obscurity = !obscurity;
                      });
                    },
                    child: Text(obscurity ? 'show' : 'hide',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueGrey))),
                label: const Text('Confirm Password')),
          ),
          Text("Something went wrong! try again",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.red)),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                if (myController2.text == myController3.text) {
                  _LoginSignUpState.getAuthSignUp(
                      myController1.text, myController2.text, context);
                } else {
                  setState(() {
                    signUpError = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16))),
              child: Text("Submit",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white)))
        ])
      ],
    );
  }
}
