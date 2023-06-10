// APPBAR

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/modules/webview_screen/webview_screen.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/bottom_sheet_menu_item.dart';
import '../../models/news.dart';
import '../../modules/search_screen/search_screen.dart';
import '../styles/colors.dart';
import 'package:shimmer/shimmer.dart';

import 'constants.dart';

Widget tab(
        {required String title,
        required bool isSelected,
        required bool isDark}) =>
    Tab(
      child: Text(
        title,
        style: TextStyle(
          color: (isSelected)
              ? (isDark)
                  ? tabSelectedColorDark
                  : tabSelectedColor
              : tabColor,
          fontSize: 18,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

Widget listOfNews({
  required int count,
  required List<dynamic>? data,
  required bool isError,
  required onRefresh,
  required AppCubit cubit,
  required BuildContext outterContext,
}) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => WebViewScreen(
                              url: data[index]['url'],
                              cubit: cubit,
                            ))));
              },
              child: Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child:
                        (data![index]['urlToImage'] != null && data.isNotEmpty)
                            ? Image.network(
                                data[index]['urlToImage'],
                                width: 150.0,
                                height: 100.0,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/noImage.jpg',
                                  width: 150,
                                  height: 100,
                                ),
                              )
                            : Image.asset(
                                'assets/images/noImage.jpg',
                                width: 150,
                                height: 100,
                              ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          (data[index]['title'] != null && data.isNotEmpty)
                              ? data[index]['title']
                              : 'No title',
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor: Colors.red,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 90,
                                  ),
                                  child: Text(
                                    (data[index]['author'] != null)
                                        ? data[index]['author']
                                        : 'No author',
                                    style: const TextStyle(
                                      fontSize: 13.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const CircleAvatar(
                                  radius: 1.2,
                                  backgroundColor: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  calculatePublishTime(
                                      time: data[index]['publishedAt']),
                                  style: const TextStyle(
                                      fontSize: 11.0, color: Colors.grey),
                                ),
                              ],
                            ),
                            newsPopupMenu(cubit, data, index, outterContext),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
          itemCount: count),
    ),
  );
}

PopupMenuButton<dynamic> newsPopupMenu(
    AppCubit cubit, List<dynamic> data, int index, BuildContext outterContext) {
  return PopupMenuButton(
    constraints: const BoxConstraints(maxWidth: 120),
    shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Colors.transparent)),
    position: PopupMenuPosition.under,
    icon: Row(
      children: const [
        CircleAvatar(
          radius: 1.5,
          backgroundColor: Colors.grey,
        ),
        SizedBox(
          width: 2.0,
        ),
        CircleAvatar(
          radius: 1.5,
          backgroundColor: Colors.grey,
        ),
        SizedBox(
          width: 2.0,
        ),
        CircleAvatar(
          radius: 1.5,
          backgroundColor: Colors.grey,
        ),
      ],
    ),
    itemBuilder: (BuildContext context) => [
      PopupMenuItem(
        enabled: false,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  (cubit.isDownloadButtonLoading)
                      ? const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator())
                      : Container(),
                  CircleAvatar(
                    backgroundColor: Colors.pink.shade50,
                    child: IconButton(
                      onPressed: () async {
                        if (cubit.isRegistered) {
                          setState(() {
                            cubit.isDownloadButtonLoading = true;
                          });
                          try {
                            cubit.insertIntoDatabaseCheck(
                                news: News(
                                    title: (data[index]['title'] != null)
                                        ? data[index]['title']
                                        : 'No title',
                                    author: (data[index]['author'] != null)
                                        ? data[index]['author']
                                        : 'No author',
                                    time: data[index]['publishedAt'],
                                    image:
                                        '${await cubit.imageHandler(data[index]['urlToImage'])}',
                                    url: data[index]['url']));
                          } catch (e) {
                            Navigator.pop(context);
                            cubit.showAlertDialog(outterContext);
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                            cubit.isDownloadButtonLoading = false;
                            cubit.isDownloadButtonError = false;
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icon(
                        (cubit.isDownloadButtonError)
                            ? Icons.error_rounded
                            : Icons.download_rounded,
                        color: Colors.pink,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 2.0,
              ),
              CircleAvatar(
                backgroundColor: Colors.pink.shade50,
                child: IconButton(
                  onPressed: () async {
                    await Clipboard.setData(
                        ClipboardData(text: data[index]['url']));
                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.pink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget listOfSearchNews({
  required int count,
  required List<dynamic>? data,
  required bool isError,
  required AppCubit cubit,
  required BuildContext outterContext,
}) =>
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WebViewScreen(
                                  url: data[index]['url'],
                                  cubit: cubit,
                                ))));
                  },
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: (data![index]['urlToImage'] != null || isError)
                            ? Image.network(
                                data[index]['urlToImage'],
                                width: 150.0,
                                height: 100.0,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/noImage.jpg',
                                  width: 150,
                                  height: 100,
                                ),
                              )
                            : Image.asset(
                                'assets/images/noImage.jpg',
                                width: 150,
                                height: 100,
                              ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              (data[index]['title'] != null)
                                  ? data[index]['title']
                                  : 'No title',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 90,
                                      ),
                                      child: Text(
                                        (data[index]['author'] != null)
                                            ? data[index]['author']
                                            : 'No author',
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const CircleAvatar(
                                      radius: 1.2,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      calculatePublishTime(
                                          time: data[index]['publishedAt']),
                                      style: const TextStyle(
                                          fontSize: 11.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                newsPopupMenu(
                                    cubit, data, index, outterContext),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10.0,
                ),
            itemCount: count),
      ),
    );

Widget listOfDownloadedNews({
  required int count,
  required List<Map<String, Object?>> data,
  required bool isError,
  required AppCubit cubit,
}) =>
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WebViewScreen(
                                  url: data[index]['url'].toString(),
                                  cubit: cubit,
                                ))));
                  },
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Image.memory(
                          base64.decode(data[index]['image'].toString()),
                          width: 150,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset('assets/images/noImage.jpg'),
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              data[index]['title'].toString(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 10.0,
                                      backgroundColor: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 90,
                                      ),
                                      child: Text(
                                        data[index]['publisher'].toString(),
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const CircleAvatar(
                                      radius: 1.2,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      calculatePublishTime(
                                          time: data[index]['time'].toString()),
                                      style: const TextStyle(
                                          fontSize: 11.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                PopupMenuButton(
                                  constraints:
                                      const BoxConstraints(maxWidth: 120),
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent)),
                                  position: PopupMenuPosition.under,
                                  icon: Row(
                                    children: const [
                                      CircleAvatar(
                                        radius: 1.5,
                                        backgroundColor: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      CircleAvatar(
                                        radius: 1.5,
                                        backgroundColor: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      CircleAvatar(
                                        radius: 1.5,
                                        backgroundColor: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                      enabled: false,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.pink.shade50,
                                            child: IconButton(
                                              onPressed: () {
                                                cubit.deleteFromDatabase(
                                                    news: News(
                                                        title: data[index]
                                                                ['title']
                                                            .toString(),
                                                        author: data[index]
                                                                ['publisher']
                                                            .toString(),
                                                        image: data[index]
                                                                ['image']
                                                            .toString(),
                                                        time: data[index]
                                                                ['time']
                                                            .toString(),
                                                        url: data[index]['url']
                                                            .toString()));
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.delete_outline_rounded,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2.0,
                                          ),
                                          CircleAvatar(
                                            backgroundColor:
                                                Colors.pink.shade50,
                                            child: IconButton(
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                    ClipboardData(
                                                        text: data[index]['url']
                                                            .toString()));
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              icon: const Icon(
                                                Icons.copy,
                                                color: Colors.pink,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 10.0,
                ),
            itemCount: count),
      ),
    );

Widget listOfNotificationNews({
  required int count,
  required List data,
  required bool isError,
  required AppCubit cubit,
}) =>
    Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.separated(
            itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => WebViewScreen(
                                  url: data[index]['url'].toString(),
                                  cubit: cubit,
                                ))));
                  },
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: (data[index]['urlToImage'] != null || isError)
                            ? Image.network(
                                data[index]['urlToImage'],
                                width: 150.0,
                                height: 80.0,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
                                  'assets/images/noImage.jpg',
                                  width: 150,
                                  height: 80,
                                ),
                              )
                            : Image.asset(
                                'assets/images/noImage.jpg',
                                width: 150,
                                height: 80,
                              ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              data[index]['title'].toString(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 5.0,
                                      backgroundColor: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      constraints: const BoxConstraints(
                                        maxWidth: 90,
                                      ),
                                      child: Text(
                                        data[index]['author'].toString(),
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    const CircleAvatar(
                                      radius: 1.2,
                                      backgroundColor: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      calculatePublishTime(
                                          time: data[index]['publishedAt']
                                              .toString()),
                                      style: const TextStyle(
                                          fontSize: 11.0, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            separatorBuilder: (context, index) => const SizedBox(
                  height: 5.0,
                ),
            itemCount: count),
      ),
    );

String calculatePublishTime({required String? time}) {
  int hours = DateTime.now().difference(DateTime.parse(time ?? '')).inHours;
  int days = 0;
  while (hours >= 24) {
    hours -= 24;
    days++;
  }
  if (days != 0) {
    return '${days}D';
  }
  return '${hours}H';
}

Widget noDownloadsHint() => const Center(
      child: Text(
        'No Downloads',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );

Widget noNotificationHint() => const Center(
      child: Text(
        'No Notifications',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );

Widget noInternetPlaceHolder() => const Center(
      child: Text(
        'No Internet Connection',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );

Widget noVideosPlaceHolder() => const Center(
      child: Text(
        'No Downloads',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );

TabBar categoriesTabBar(
        {required AppCubit cubit,
        required bool isDark,
        required Map textData}) =>
    TabBar(
      isScrollable: true,
      indicatorColor: tabIndicatorColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorPadding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
      indicatorWeight: tabIndicatorWeight,
      onTap: (index) {
        cubit.updateSelectedTab(index);
      },
      tabs: [
        tab(
            title: textData['categories']['general'],
            isSelected: cubit.currentTabIndex == 0,
            isDark: isDark),
        tab(
            title: textData['categories']['business'],
            isSelected: cubit.currentTabIndex == 1,
            isDark: isDark),
        tab(
            title: textData['categories']['entertainment'],
            isSelected: cubit.currentTabIndex == 2,
            isDark: isDark),
        tab(
            title: textData['categories']['health'],
            isSelected: cubit.currentTabIndex == 3,
            isDark: isDark),
        tab(
            title: textData['categories']['sports'],
            isSelected: cubit.currentTabIndex == 4,
            isDark: isDark),
        tab(
            title: textData['categories']['science'],
            isSelected: cubit.currentTabIndex == 5,
            isDark: isDark),
        tab(
            title: textData['categories']['technology'],
            isSelected: cubit.currentTabIndex == 6,
            isDark: isDark),
      ],
    );

Widget loadingEffect() => Shimmer.fromColors(
    baseColor: Colors.grey.shade400,
    highlightColor: Colors.grey.shade200,
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.separated(
          itemBuilder: (context, index) => Row(
                children: [
                  Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Container(
                      height: 120,
                      width: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 10,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 10.0,
                                  backgroundColor: Colors.red,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  height: 10,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const CircleAvatar(
                                  radius: 2.0,
                                  backgroundColor: Colors.grey,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
          itemCount: 6),
    ));

Widget bottomSheetMenu({required bool isDark, required Map textData}) {
  List<BottomSheetMenuItem> bottomSheetMenuItems = [
    BottomSheetMenuItem(
        itemName: textData['bottomSheetMenu']['our-apps'],
        itemIcon: Icons.play_circle,
        func: () {}),
    BottomSheetMenuItem(
        itemName: textData['bottomSheetMenu']['our-webSite'],
        itemIcon: Icons.web_asset,
        func: () {}),
    BottomSheetMenuItem(
      itemName: textData['bottomSheetMenu']['share-app'],
      itemIcon: Icons.share,
      func: () {
        Share.share('https://newsApp.com/share');
      },
    ),
    BottomSheetMenuItem(
        itemName: textData['bottomSheetMenu']['open-source-licenses'],
        itemIcon: Icons.document_scanner_outlined,
        func: () {}),
  ];

  return SingleChildScrollView(
    child: Directionality(
      textDirection: (textData['lang-data']['name'] == 'Arabic')
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          bottomSheetMenuItems[index].func();
                        },
                        child: Row(
                          children: [
                            Icon(
                              bottomSheetMenuItems[index].itemIcon,
                              color: (isDark) ? iconColorDark : iconColorLight,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              bottomSheetMenuItems[index].itemName,
                              style: const TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      height: 20,
                    ),
                itemCount: bottomSheetMenuItems.length),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(textData['bottomSheetMenu']['privacy-policy']),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  CircleAvatar(
                    radius: 2.0,
                    backgroundColor: (isDark) ? iconColorDark : iconColorLight,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  TextButton(
                    child:
                        Text(textData['bottomSheetMenu']['terms-of-service']),
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget meMenuItem(
    {required String title,
    required IconData icon,
    required onPressed,
    required bool isDropDown,
    AppCubit? cubit,
    List? items,
    String? actionText}) {
  return (!isDropDown)
      ? TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  icon,
                  size: 28,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                (actionText != null)
                    ? Text(
                        actionText,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade400),
                      )
                    : const Text(''),
              ],
            ),
          ),
        )
      : Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 19.0,
            end: 10.0,
            top: 10.0,
            bottom: 10.0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 1.0,
              ),
              Icon(
                icon,
                size: 28,
              ),
              const SizedBox(
                width: 5.0,
              ),
              DropdownButton(
                value: cubit?.currentCountryString,
                items: items!
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))
                    .toList(),
                onChanged: ((value) {
                  cubit?.changeCurrentSelectedCountry(value!);
                  cubit?.refreshAllNewsCategories();
                }),
                underline: Container(),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ],
          ),
        );
}

AppBar mainAppBar(void Function(dynamic cubit) showBottomS, AppCubit cubit,
    BuildContext context, bool isDark, scaffoldKey) {
  return AppBar(
    key: scaffoldKey,
    title: Text(
      cubit.textData['app-title']?['name'] ?? appTitle,
      style: TextStyle(
        color: titleColor,
        fontSize: appBarTitleSize,
        fontWeight: FontWeight.w500,
      ),
    ),
    centerTitle: true,
    elevation: 0,
    leading: IconButton(
        onPressed: () => showBottomS(cubit), icon: const Icon(Icons.menu)),
    actions: [
      IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SearchScreen()));
          },
          icon: const Icon(Icons.search)),
    ],
    iconTheme: IconThemeData(
      color: appBarIconColor,
      size: appBarIconSize,
    ),
    bottom: cubit.getBottomAppBarViews(
        cubit, isDark)[cubit.currentBottomNavigationBarIndex],
  );
}
