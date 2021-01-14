import 'package:flutter/material.dart';

class NotAuthorizedScreen extends StatelessWidget {
  static String routeName = "/not_authorized";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Authorized'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Spacer(),
            Text('401 - Not Authorized', style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 8.0,),
            Text('Please make sure you are logged into the right account or try logging in again.', textAlign: TextAlign.center,),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
