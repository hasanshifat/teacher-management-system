import 'package:flutter/material.dart';
import 'package:tms/colors.dart';
import 'text_field_container.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final Function press;
  final Function validatr;
  final String errorsText;
  final bool obscuretext;
  final TextEditingController controlerText;
  const RoundedPasswordField({
    Key key,
    this.errorsText,
    this.controlerText,
    this.obscuretext,
    this.validatr,
    this.onChanged,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controlerText,
        obscureText: obscuretext,
        autofocus: false,
        keyboardType: TextInputType.visiblePassword,
        onChanged: onChanged,
        cursorColor: kPrimaryColor1,
        validator: validatr,
        decoration: InputDecoration(
          hintText: "Password",
          errorText: errorsText,
          icon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.lock,
              color: kPrimaryColor3,
            ),
          ),
          suffixIcon: IconButton(
            color: obscuretext ?kPrimaryColor3:kPrimaryColor4,
              icon: Icon(obscuretext ? Icons.visibility : Icons.visibility_off),
              onPressed: press),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
