import 'package:flutter_screenutil/flutter_screenutil.dart';

extension ScreenUtilClamped on num {
  double get hc {
    final double scaled = h;
    return scaled.clamp(1.0, toDouble());
  }

  double get wc {
    final double scaled = w;
    return scaled.clamp(1.0, toDouble());
  }

  double get spc {
    final double scaled = sp;
    return scaled.clamp(1.0, toDouble());
  }
}
