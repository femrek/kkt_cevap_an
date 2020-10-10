import 'package:flutter/material.dart';

class DialogCheckbox extends StatefulWidget {

  _DialogCheckboxState __dialogCheckboxState;

  bool isChecked() {
    return __dialogCheckboxState.savePdfToStorageCheckBoxValue;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    __dialogCheckboxState = _DialogCheckboxState();
    return __dialogCheckboxState;
  }
}

class _DialogCheckboxState extends State<DialogCheckbox> {

  bool savePdfToStorageCheckBoxValue = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
          value: savePdfToStorageCheckBoxValue,
          onChanged: (bool value) {
            setState(() {
              savePdfToStorageCheckBoxValue = value;
            });
          },
        ),
        Expanded(child: Text('Telefon hafızasına kaydetmek istemiyorum'))
      ],
    );
  }

}