import 'package:flutter/material.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.textBootom,
  });
  final String imagePath, title, subtitle, textBootom;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: size.height * 0.35,
              width: double.infinity,
            ),
            const Text(
              "Whoops",
              style: TextStyle(fontSize: 40, color: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(20),
                elevation: 0,
              ),
              onPressed: () {
                //  Navigator.pushReplacementNamed(context, RootView.routeName);
              },
              child: Text(textBootom, style: const TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}
