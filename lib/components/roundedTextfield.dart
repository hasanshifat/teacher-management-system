import 'package:flutter/material.dart';
import 'package:tms/colors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controlerText;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
    this.controlerText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        textInputAction: TextInputAction.next,
        autofocus: false,
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        controller: controlerText,
        cursorColor: kPrimaryColor3,
        decoration: InputDecoration(
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              icon,
              color: kPrimaryColor3,
            ),
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
