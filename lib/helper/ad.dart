import 'dart:io';

class ad {
  String getfirstpageadunit() {
    if (Platform.isAndroid) {
      String androidadunit = 'ca-app-pub-6812988945725571/6356328399';
      return androidadunit;
    } else {
      throw Error();
    }
  }
}
