import 'dart:math';
import 'package:flutter/material.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextAlign? textAlign;

  const ResponsiveText(
    this.text, {
    this.style,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // Determine responsive font size
    double fontSize = style?.fontSize ?? 14;

    if (width < 400) {
      fontSize = 10;
    } else if (width < 600) {
      fontSize = 11;
    } else if (width < 800) {
      fontSize = 12;
    } else if (width < 1000) {
      fontSize = 13;
    } else if (width < 1200) {
      fontSize = 14;
    } else if (width < 1600) {
      fontSize = 16;
    } else {
      fontSize = 18;
    }

    return Text(
      text,
      style: style?.copyWith(fontSize: fontSize),
      maxLines: maxLines ?? 1,
      overflow: overflow ?? TextOverflow.ellipsis,
      softWrap: softWrap ?? true,
      textAlign: textAlign,
    );
  }
}
