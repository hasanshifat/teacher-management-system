import 'package:flutter/material.dart';
import 'package:tms/colors.dart';
import 'text_field_container.dart';

class RoundedMobileNumberField extends StatelessWidget {
  final String hintText;
  final String errorsText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controlerText;
  const RoundedMobileNumberField({
    Key key,
    this.hintText,
    this.errorsText,
    this.controlerText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        textInputAction: TextInputAction.next,
        autofocus: false,
        keyboardType: TextInputType.phone,
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
          errorText: errorsText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
