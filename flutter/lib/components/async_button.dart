import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_toxicity_scanner/constants.dart';


/// A widget that shows a [CircularProgressIndicator] while an async task is in progress.
///
/// Both the button text and onPressed function are required. For [successText] and
/// [failText] to work you must return a [bool] value of true when the function is
/// successful and false when not. The widget will handle the rest.
class AsyncButton extends StatefulWidget {
  final String text;
  final Function press;
  final String successText;
  final String failText;
  final Duration finishedDuration;

  const AsyncButton({
    Key key,
    @required
    this.text,
    @required
    this.press,
    this.successText,
    this.failText,
    this.finishedDuration,
  }) : assert(text != null),
       assert(press != null),
       super(key: key);

  @override
  _AsyncButtonBuilder createState() => _AsyncButtonBuilder();
}

class _AsyncButtonBuilder extends State<AsyncButton> {
  String text = '';
  Widget textWidget;
  Function press;
  String successText;
  String failText;
  Duration finishedDuration;


  @override
  void initState() {
    super.initState();
    text = widget.text;
    buildText(text);
    press = widget.press;
    successText = widget.successText;
    failText = widget.failText;
    finishedDuration = widget.finishedDuration ?? Duration(seconds: 2);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.0,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return FlatButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Theme.of(context).primaryColor,
              onPressed: () => onPressed(setState),
              child: AnimatedSwitcher(
                duration: kAnimationDuration,
                child: textWidget,
              ),
          );
        }
      ),
    );
  }

  void buildText(String text, [StateSetter stateSetter]) {
    textWidget =  Text(
      text,
      key: UniqueKey(),
      style: TextStyle(color: Colors.white, fontSize: 18.0,),
    );

    if (stateSetter != null) setState(() {});
  }

  void buildTextWithTimer(String text, StateSetter stateSetter) {
    buildText(text, setState);
    new Timer(finishedDuration, () => buildText(this.text, setState));
  }

  void onPressed(StateSetter setState) {
    setState(() {
      textWidget = CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),);
    });

    press().then((success) {
      if (successText != null && success) {
        buildTextWithTimer(successText, setState);
      } else if (failText != null && !success) {
        buildTextWithTimer(failText, setState);
      } else {
        buildText(text, setState);
      }
    });
  }
}
