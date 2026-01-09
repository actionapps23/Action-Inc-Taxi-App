import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  final BuildContext context;

  DeviceUtils(this.context);

  double get _width => MediaQuery.of(context).size.width;

  bool get isExtraSmallMobile => _width < 400;
  bool get isSmallMobile => _width >= 400 && _width < 600;
  bool get isMediumMobile => _width >= 600 && _width < 768;
  bool get isTablet => _width >= 768 && _width < 1024;
  bool get isLargeTablet => _width >= 1024 && _width < 1440;
  bool get isDesktop => _width >= 1440;
  

  double getResponsiveWidth(){
    if(isExtraSmallMobile){
      return 0.9;
    } else if(isSmallMobile){
      return 0.8;
    } else if(isMediumMobile){
      return 0.7;
    } else if(isTablet){
      return 0.6;
    } else if(isLargeTablet){
      return 0.5;
    } else {
      return 0.4;
    }
  }

  bool get isWeb => kIsWeb;

  bool get isPortrait =>
      MediaQuery.of(context).orientation == Orientation.portrait;
  bool get isLandscape =>
      MediaQuery.of(context).orientation == Orientation.landscape;
}
