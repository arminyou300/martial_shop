import 'package:flutter/material.dart';

class PrettyTextField extends StatefulWidget {
  PrettyTextField({
    super.key,
    required this.controller,
    required this.errorText,
    required this.hintText,
    required this.fieldColor,
    required this.hiddenText,
    required this.isEmail,
  });

  final TextEditingController controller;
  final String errorText;
  final String hintText;
  final Color fieldColor;
  late bool hiddenText;
  final bool isEmail;

  @override
  State<PrettyTextField> createState() => _PrettyTextFieldState();
}

class _PrettyTextFieldState extends State<PrettyTextField> {
  bool _validate = false;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: TextField(
            controller: widget.controller,
            textAlign: TextAlign.left,
            textInputAction: TextInputAction.next,
            obscureText: showPassword,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: widget.isEmail
                ? TextInputType.emailAddress
                : TextInputType.name,
            decoration: InputDecoration(
              errorText: _validate ? widget.errorText : null,
              suffixIcon: widget.hiddenText == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      icon: Icon(
                        showPassword == true
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                      ),
                    )
                  : null,
              counterText: "",
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
            style: TextStyle(
              color: widget.fieldColor,
            ),
            onTapOutside: (event) => FocusScope.of(context).requestFocus(
              FocusNode(),
            ),
          ),
        ),
      ),
    );
  }
}
