import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/modules/home_screen/home_screen.dart';
import 'package:newsapp/shared/cubit/cubit_states.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';
import 'package:newsapp/shared/local/shared_data.dart';
import 'package:newsapp/shared/network/dio_helper.dart';
import 'package:newsapp/shared/styles/colors.dart';
import 'shared/components/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await SharedPreferencesHandler.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>()!;
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  ThemeMode currentThemeMode =
      (SharedPreferencesHandler.getBooleanData(key: themeModeKey) == true)
          ? ThemeMode.dark
          : ThemeMode.light;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..checkInternetConnection()
        ..initDatabase()
        ..initNews()
        ..readFromDatabase()
        ..handleStorages()
        ..notificationListHandler()
        ..initLanguage(),
      child: BlocListener<AppCubit, AppState>(
        listener: (BuildContext context, state) {
          if (state is LanguageStringState) {
            BlocProvider.of<AppCubit>(context).initLanguage();
          }
        },
        child: MaterialApp(
          title: 'News App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: lightModeColor,
            appBarTheme: AppBarTheme(
              backgroundColor: lightModeColor,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: lightModeColor,
                systemNavigationBarColor: lightModeColor,
                statusBarIconBrightness: Brightness.dark,
              ),
              iconTheme: const IconThemeData(
                color: Colors.pink,
              ),
            ),
            textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.black))),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.pink,
              showUnselectedLabels: false,
              showSelectedLabels: false,
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: darkModeColor,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            textButtonTheme: const TextButtonThemeData(
                style: ButtonStyle(
                    iconColor: MaterialStatePropertyAll(Colors.white))),
            appBarTheme: AppBarTheme(
              backgroundColor: darkModeColor,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: darkModeColor,
                systemNavigationBarColor: darkModeColor,
                statusBarIconBrightness: Brightness.light,
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: darkModeColor,
            ),
            textTheme: const TextTheme(
              displaySmall: TextStyle(
                color: Colors.white,
              ),
              displayMedium: TextStyle(
                color: Colors.white,
              ),
              displayLarge: TextStyle(
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
              ),
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              titleSmall: TextStyle(
                color: Colors.white,
              ),
              titleMedium: TextStyle(
                color: Colors.white,
              ),
              titleLarge: TextStyle(
                color: Colors.white,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: darkModeColor,
              selectedItemColor: Colors.pink,
              unselectedIconTheme: const IconThemeData(
                color: Colors.white,
              ),
              showUnselectedLabels: false,
              showSelectedLabels: false,
            ),
          ),
          themeMode: currentThemeMode,
          home: const HomeScreen(),
        ),
      ),
    );
  }

  // Themes Logic
  void changeThemeMode() {
    setState(() {
      if (currentThemeMode == ThemeMode.light) {
        currentThemeMode = ThemeMode.dark;
        SharedPreferencesHandler.setBooleanData(key: themeModeKey, value: true);
      } else {
        currentThemeMode = ThemeMode.light;
        SharedPreferencesHandler.setBooleanData(
            key: themeModeKey, value: false);
      }
    });
  }
}
