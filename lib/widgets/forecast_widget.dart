import 'package:flutter/material.dart';
import 'package:flutter_app_test/widgets/blank_widget.dart';

class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ValueTile(this.label, this.value, {this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          height: 5,
        ),
        this.iconData != null
            ? Icon(
          iconData,
          color: Colors.white,
          size: 20,
        )
            : BlankWidget(),
        SizedBox(
          height: 10,
        ),
        Text(
          this.value,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
