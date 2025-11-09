import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Spacing {
  static final SizedBox vSmall = SizedBox(height: 4.h);
  static final SizedBox vStandard = SizedBox(height: 8.h);
  static final SizedBox vMedium = SizedBox(height: 16.h);
  static final SizedBox vLarge = SizedBox(height: 24.h);
  static final SizedBox vExtraLarge = SizedBox(height: 32.h);
  static final SizedBox vXXLarge = SizedBox(height: 48.h);

  static final SizedBox hSmall = SizedBox(width: 4.w);
  static final SizedBox hStandard = SizedBox(width: 8.w);
  static final SizedBox hMedium = SizedBox(width: 16.w);
  static final SizedBox hLarge = SizedBox(width: 24.w);
  static final SizedBox hExtraLarge = SizedBox(width: 32.w);
  static final SizedBox hXXLarge = SizedBox(width: 48.w);

  static final SizedBox fullWidth = SizedBox(width: double.infinity);
  static final SizedBox fullHeight = SizedBox(height: double.infinity);

  static SizedBox vSize(double size) => SizedBox(height: size.h);
  static SizedBox hSize(double size) => SizedBox(width: size.w);
}
