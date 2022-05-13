import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mtm/views/map_screen.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 788),
      builder: (child) => ProviderScope(
        child: MaterialApp(
          builder: (ctx, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(ctx, widget!),
            maxWidth: 1200,
            minWidth: 412,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(412, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: const ColoredBox(color: Color(0xFFF5F5F5)),
          ),
          title: 'MTMs',
          theme: ThemeData(
            primaryColor: const Color(0xFF0860A8),
            scaffoldBackgroundColor: const Color(0xFFF5F5F5),
            visualDensity: VisualDensity.standard,
          ),
          debugShowCheckedModeBanner: false,
          home: const MapScreen(),
        ),
      ),
    );
  }
}
