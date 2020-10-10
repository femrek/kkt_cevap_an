import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {

  RadioButton({
    @required this.onChanged,
    @required this.value,
    @required this.groupValue,
    this.label,
    this.textColor,
    this.textActiveColor,
    this.radioUnselectedColor,
    this.radioActiveColor,
  });

  String label = '';
  ValueChanged<dynamic> onChanged;
  dynamic value;
  dynamic groupValue;

  Color textColor;
  Color textActiveColor;

  Color radioUnselectedColor;
  Color radioActiveColor;


  @override
  State<StatefulWidget> createState() {
    return _RadioButtonState();
  }
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: widget.radioUnselectedColor,
              ),
              child: Radio(
                activeColor: widget.radioActiveColor,
                value: widget.value,
                groupValue: widget.groupValue,
                onChanged: widget.onChanged,
              ),
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.groupValue == widget.value ? widget.textActiveColor : widget.textColor,
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }


}