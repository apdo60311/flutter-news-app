import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/main.dart';
import 'package:newsapp/shared/components/components.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';
import '../../shared/cubit/cubit_states.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var mainApp = MyApp.of(context);
    bool isDark = (mainApp.currentThemeMode == ThemeMode.dark);
    void showBottomS(cubit) {
      showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
            ),
          ),
          context: context,
          builder: ((context) =>
              bottomSheetMenu(isDark: isDark, textData: cubit.textData)),
          isScrollControlled: true);
    }

    return BlocConsumer<AppCubit, AppState>(
      listener: (BuildContext context, Object? state) {},
      builder: (BuildContext context, state) {
        AppCubit cubit = AppCubit.get(context);
        return DefaultTabController(
          length: cubit.newsCategories.length,
          child: Builder(
            builder: (BuildContext context) {
              DefaultTabController.of(context).addListener(() {
                cubit.updateSelectedTab(DefaultTabController.of(context).index);
              });
              return Scaffold(
                appBar: mainAppBar(
                    showBottomS, cubit, context, isDark, scaffoldKey),
                body: cubit.getBottomNavigationBarViews(
                    cubit)[cubit.currentBottomNavigationBarIndex],
                bottomNavigationBar: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(
                          Icons.home_outlined,
                        ),
                        activeIcon: Icon(Icons.home),
                        label: 'Home'),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite_border_outlined),
                      activeIcon: Icon(Icons.favorite),
                      label: 'Favorite',
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.notifications_none_outlined),
                        activeIcon: Icon(Icons.notifications_rounded),
                        label: 'notifications'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outlined),
                        activeIcon: Icon(Icons.person),
                        label: 'me'),
                  ],
                  currentIndex: cubit.currentBottomNavigationBarIndex,
                  onTap: (index) {
                    cubit.changeBottomNavigationBarCurrentIndex(index);
                    cubit.handleSpecialEventsInBottomNavBar(index);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
