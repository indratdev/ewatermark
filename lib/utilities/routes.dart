import 'package:flutter/cupertino.dart';

import '../screens/ewatermark_new.dart';
import '../screens/splash_screen/splash_screen.dart';

class Routes {
  Map<String, WidgetBuilder> getRoutes = {
    '/splash': (_) => SplashScreen(),
    // '/': (_) => EWatermark(),
  };
}
