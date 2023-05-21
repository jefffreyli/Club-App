import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

String appName = 'SciClubs';
TextStyle h3 = const TextStyle(
    color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500);
TextStyle h2 = const TextStyle(
    color: Colors.black, fontSize: 24, fontWeight: FontWeight.w500);
TextStyle h4 = const TextStyle(
    color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500);

Color blue = const Color(0xff8DBBF1);
Color red = const Color(0xffF9CEDF);
Color yellow = const Color(0xffFDEECB);
Color yellowOrange = const Color(0xffFFECC7);
Color yellowOrangeDark = const Color(0xff6D392F);
Color grey = const Color(0xffD7DDE9);
Color green_1 = const Color(0xff2CA63E);
Color green_2 = Color.fromARGB(255, 2, 123, 105);

String fillerNetworkImage =
    "https://i.seadn.io/gae/2hDpuTi-0AMKvoZJGd-yKWvK4tKdQr_kLIpB_qSeMau2TNGCNidAosMEvrEXFO9G6tmlFlPQplpwiqirgrIPWnCKMvElaYgI-HiVvXc?auto=format&w=1000";

void navigate(BuildContext context, Widget w) {
  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => w),
  );
}

void showSnackbar(
  String message,
  Color? color,
  BuildContext context,
) {
  final snackBar = SnackBar(
    backgroundColor: color,
    content: Text(message),
    action: SnackBarAction(
      label: message,
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.red, opacity: 0.8),
  );
}
