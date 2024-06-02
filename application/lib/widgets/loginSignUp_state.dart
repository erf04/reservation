import 'package:application/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({super.key});

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  bool isInError = false;
  bool isInSignUp = false;
  bool obscurity = true;
  TextEditingController myController1 = TextEditingController();
  TextEditingController myController2 = TextEditingController();
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
              image: AssetImage('assets/images.jpg'),
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
                : MediaQuery.of(context).size.height * 0.52,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: isInSignUp ? getSignUp(context) : getLogin(context),
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
                    color: isInSignUp ? Colors.black54 : Colors.orange),
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
                    color: isInSignUp ? Colors.orange : Colors.black54),
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
                            color: Colors.blue))),
                label: const Text('Password')),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No account yet?"),
              SizedBox(
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
                        .copyWith(color: Colors.blue),
                  ))
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.orange,
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
                    color: isInSignUp ? Colors.black54 : Colors.orange),
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
                    color: isInSignUp ? Colors.orange : Colors.black54),
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
                            color: Colors.blue))),
                label: const Text('Password')),
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
                            color: Colors.blue))),
                label: const Text('Confirm Password')),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                  backgroundColor: Colors.orange,
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
