import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';

class CustomTextFields extends StatelessWidget {
  CustomTextFields({
    @required this.width,
    @required this.height,
    @required this.textController,
    @required this.node,
    this.contentPadding,
    @required this.keyboardType,
    @required this.textInputAction,
    this.obscureText,
    @required this.onChanged,
    @required this.onEditingComplete,
    @required this.onFieldSubmitted,
    this.errorText,
    this.suffix,
    this.prefix,
    @required this.labelText,
    @required this.helperText,
    @required this.hintText,
    this.isDense,
    this.readOnly,
    this.textAlign,
  });

  final TextEditingController textController;
  final String labelText;
  final String errorText;
  final String helperText;
  final String hintText;
  final FocusNode node;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final Function onChanged;
  final Function onEditingComplete;
  final Function onFieldSubmitted;
  final Widget suffix;
  final Widget prefix;
  final double height;
  final double width;
  final EdgeInsets contentPadding;
  final bool isDense;
  final bool readOnly;
  TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: height, //MediaQuery.of(context).size.height * 0.103, 65
        width: width, //MediaQuery.of(context).size.width * 0.84,
        decoration: ktextFieldDecoration,
        child: TextFormField(
          textAlign: textAlign ?? TextAlign.left,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onFieldSubmitted,
          controller: textController,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: node,
          readOnly: readOnly,
          obscureText: obscureText ?? false,
          cursorColor: errorText == null ? kprimaryColor : kerrorColor,
          cursorRadius: Radius.circular(25),
          cursorWidth: 1,
          style: TextStyle(
            height: 1.5,
            color: errorText == null ? kprimaryColor : kerrorColor,
            fontSize: 19,
          ),
          decoration: InputDecoration(
            contentPadding: contentPadding,
            helperText: helperText,
            helperStyle: TextStyle(fontSize: 10, color: kheadingColor2),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 15, height: 1.2, color: Colors.green.shade200),
            suffix: suffix,
            prefix: prefix,
            fillColor: errorText == null ? Color(0xffF6FDF6) : Color(0xffFDF6F6),
            filled: true,
            isDense: isDense,
            labelText: labelText,
            labelStyle: TextStyle(color: kheadingColor2, fontSize: 15, height: 1.2),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: kprimaryColor,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: errorText == null ? Colors.green.shade100 : Colors.red.shade100,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: kerrorColor,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            errorText: errorText,
            errorStyle: TextStyle(color: kerrorColor, fontSize: 10),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: kerrorColor,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ),
    );
  }
}
