import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinCodeField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controlerText;

  const PinCodeField({
    Key key,
    this.onChanged,
    this.controlerText
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: PinCodeTextField(
        length: 6,
        obscureText: false,
        controller: controlerText,
        animationType: AnimationType.slide,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        
        enableActiveFill: true,
        //errorAnimationController: errorController,
        
        onCompleted: (v) {
          print("Completed");
        },
        onChanged: (value) {
          print(value);
          // setState(() {
          //   currentText = value;
          // });
        },
        beforeTextPaste: (text) {
          print("Allowing to paste $text");

          return true;
        },
        appContext: context,
      ),
    );
  }
}
