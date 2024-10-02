import 'package:flutter/material.dart';

class Txt extends StatefulWidget {
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final bool useOverflow;
  final bool upperCaseFirst;
  final bool useQuotes;
  final bool useFiler;
  final bool underlined;
  final bool fullUpperCase;
  final bool fullLowerCase;
  final dynamic text;
  final String? fontFamily;
  final double? letterSpacing;

  const Txt({
    Key? key,
    this.fontStyle,
    this.fontWeight,
    this.maxLines,
    this.fontSize,
    this.color,
    this.textAlign,
    this.useOverflow = false,
    this.upperCaseFirst = false,
    this.useQuotes = false,
    this.useFiler = false,
    this.underlined = false,
    this.fullUpperCase = false,
    this.fullLowerCase = false,
    required this.text,
    this.fontFamily,
    this.letterSpacing,
  }) : super(key: key);

  @override
  _TxtState createState() => _TxtState();
}

class _TxtState extends State<Txt> {
  String? finalText = "Null";

  @override
  Widget build(BuildContext context) {
    bool isString = widget.text is String;
    bool isNumber = widget.text is double || widget.text is int;
    bool isOthers = isString == false && isNumber == false;

    if (isString) {
      finalText = widget.text ?? "Error";
    }
    if (isNumber) finalText = '${widget.text}';
    if (isOthers) finalText = "Invalid input ${widget.text}";


    if (widget.fullLowerCase) finalText = finalText!.toLowerCase();


    if (widget.fullUpperCase) finalText = finalText!.toUpperCase();


    if (widget.upperCaseFirst && finalText!.length > 1) {
      finalText =
          "${finalText![0].toUpperCase()}${finalText!.substring(1, finalText!.length).toLowerCase()}";
    }


    if (widget.useQuotes) finalText = "❝$finalText❞";


    if (widget.useFiler) {
      finalText = finalText!
          .replaceAll("*", "")
          .replaceAll("_", "")
          .replaceAll("-", "")
          .replaceAll("#", "")
          .replaceAll("\n", "")
          .replaceAll("!", "")
          .replaceAll('[', '')
          .replaceAll(']', '');
    }

    return Text(
      (finalText ?? "Error").toString(),
      overflow: widget.useOverflow ? TextOverflow.ellipsis : null,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      textScaleFactor: 1,
      style: TextStyle(
        decoration: widget.underlined ? TextDecoration.underline : null,
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
        fontStyle: widget.fontStyle,
        fontFamily: "Work Sans",
        letterSpacing: widget.letterSpacing,
      ),
    );
  }
}
