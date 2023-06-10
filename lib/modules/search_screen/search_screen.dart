import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/shared/components/components.dart';
import 'package:newsapp/shared/cubit/cubit_states.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';

import '../../main.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        var mainApp = MyApp.of(context);
        bool isDark = (mainApp.currentThemeMode == ThemeMode.dark);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              appTitle,
              style: TextStyle(
                color: titleColor,
                fontSize: appBarTitleSize,
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.pink),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  onChanged: (value) {
                    cubit.searchListHandler(value: value);
                  },
                  onTapOutside: (event) {},
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                      hintText: cubit.textData['search-data']
                          ?['search-bar-hint'],
                      hintStyle: TextStyle(color: searchbarHintTextColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (isDark) ? Colors.white : Colors.black),
                        borderRadius: BorderRadius.circular(15.0),
                      )),
                ),
              ),
              listOfSearchNews(
                count: cubit.searchNewsList.length,
                data: cubit.searchNewsList,
                isError: false,
                cubit: cubit,
                outterContext: context,
              ),
            ],
          ),
        );
      },
    );
  }
}
