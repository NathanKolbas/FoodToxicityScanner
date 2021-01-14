import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_toxicity_scanner/screens/camera/camera_screen.dart';

import '../../../size_config.dart';

class ScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            backgroundColor: Colors.grey.shade50,
            elevation: 0.0,
            title: Text(
              'How to scan ingredients',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  // decoration: TextDecoration.underline,
                  color: Colors.black
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0,),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Scanning an ingredients label is really easy. Simply point your camera at the label and click the shutter button (',
                            ),
                            WidgetSpan(child: Icon(Icons.camera, size: 16.0,)),
                            TextSpan(
                              text: ') to take a photo.',
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0,),
                        child: SvgPicture.asset(
                          'assets/images/Example1.svg',
                          height: getProportionateScreenHeight(265),
                          width: getProportionateScreenWidth(235),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'The app will then analyze the photo for text and draw a red box around it. Simply click on the red box around the ingredients label. (Tip: If the box is broken up into multiple pieces then try taking the photo further away.)',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0,),
                        child: SvgPicture.asset(
                          'assets/images/Example2.svg',
                          height: getProportionateScreenHeight(265),
                          width: getProportionateScreenWidth(235),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'After a moment, the ingredients will be analyzed and the safety of each one reported back to you. Some of the ingredients you scanned might not have information in the database. Feel free to contribute your own knowledge about the ingredient. Your contribution will be marked down in history with your own name crediting the contribution of the ingredient.',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(8),
          getProportionateScreenWidth(18),
          getProportionateScreenWidth(28),
        ),
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Start scanning", style: TextStyle(color: Colors.white),),
              SizedBox(width: 8.0),
              Icon(Icons.camera_alt, color: Colors.white,),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Theme.of(context).primaryColor,
          onPressed: () => Navigator.pushNamed(context, CameraScreen.routeName),
        ),
      ),
    );
  }
}
