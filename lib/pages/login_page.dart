import 'package:flutter/material.dart';

//This page is the title page of the application.
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xffA9A9A9),
              Color(0xff383838),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.6,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  )),
                  minimumSize: MaterialStateProperty.all(const Size(130, 60)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color(0xffFFD600))),
              onPressed: () {
                //The button sends a route through the  navigator widget to the next window (Window with all tasks)
                Navigator.pushNamed(
                  context,
                  '/first',
                );
              },
              child: const Text(
                "Вхід",
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff383838),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
