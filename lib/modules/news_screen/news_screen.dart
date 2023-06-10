import 'package:flutter/material.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';

import '../../shared/components/components.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key, required this.cubit});

  final AppCubit cubit;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[0]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[0]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[1]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[1]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[2]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[2]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[3]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[3]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[4]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[4]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[5]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[5]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
        (cubit.isInternetConnectionAvailable)
            ? (cubit.newsList
                    .containsKey(cubit.newsCategories[cubit.currentTabIndex]))
                ? listOfNews(
                    cubit: cubit,
                    count: cubit.newsList.length,
                    data: cubit.newsList[cubit.newsCategories[6]],
                    isError: cubit.apiError,
                    onRefresh: () async {
                      cubit.refreshList(category: cubit.newsCategories[6]);
                    },
                    outterContext: context,
                  )
                : loadingEffect()
            : noInternetPlaceHolder(),
      ],
    );
  }
}
