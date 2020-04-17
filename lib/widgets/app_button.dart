import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  @override
  String text;
  Function onPressed;
  bool showProgress;

  AppButton(this.text, {this.onPressed, this.showProgress = false});

  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(15.0),
        ),
        color: Colors.black12,
        child: showProgress
            ? Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                ),
              ),
        onPressed: onPressed,
      ),
    );
  }
}
