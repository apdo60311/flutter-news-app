import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newsapp/modules/news_screen/news_screen.dart';
import 'package:newsapp/modules/download_screen/download_screen.dart';
import 'package:newsapp/modules/notification_screen/notification_screen.dart';
import 'package:newsapp/shared/local/shared_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/country_options.dart';
import '../../models/language.dart';
import '../../models/news.dart';
import '../../modules/me_page/me_page.dart';
import '../components/components.dart';
import '../components/constants.dart';
import '../network/dio_helper.dart';
import 'cubit_states.dart';
import 'package:http/http.dart' as http show get;

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(IntialAppState());

  static AppCubit get(context) => BlocProvider.of(context);

  // handle TabBar
  int currentTabIndex = 0;
  void updateSelectedTab(int index) {
    currentTabIndex = index;
    emit(CurrentTabChangeState());
  }

  // handle api

  List newsCategories = [
    'general',
    'business',
    'entertainment',
    'health',
    'sports',
    'technology',
    'science'
  ];

  List newsCategoriesArabic = [];

  int totalNewsCount = 0;

  Map<String, List> newsList = {};

  bool apiError = false;
  void initNews() {
    for (var element in newsCategories) {
      initNewsList(category: element);
    }
  }

  void initNewsList({required String category}) {
    currentCountryCodeString =
        CountryHandler.getCountryCode(currentCountryString!);
    DioHelper.getData(url: '/v2/top-headlines', queryParameters: {
      'apiKey': apiKey,
      'country': currentCountryCodeString,
      'category': category,
    }).then((value) {
      newsList[category] = value?.data['articles'];
      totalNewsCount = value?.data['totalResults'];
      apiError = false;
      emit(ReadNewsFromApiSuccessState());
    }).onError((error, stackTrace) {
      apiError = true;
    });
  }

  // handle refresh list of news

  void refreshList({required String category}) {
    Future.delayed(const Duration(seconds: 2));
    initNewsList(
      category: category,
    );
    emit(RefreshNewsListState());
  }

  void refreshAllNewsCategories() {
    for (var category in newsCategories) {
      refreshList(category: category);
    }
  }

  // check internet connection

  bool isInternetConnectionAvailable = true;

  void checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isInternetConnectionAvailable = true;
      }
    } on SocketException catch (_) {
      isInternetConnectionAvailable = false;
    }
  }

  // handle bottomNavigationBar
  int currentBottomNavigationBarIndex = 0;

  List getBottomNavigationBarViews(cubit) {
    List bottomNavigationBarViews = [
      NewsScreen(cubit: cubit),
      const DownloadScreen(),
      const NotificationScreen(),
      MePage(cubit: cubit),
    ];

    return bottomNavigationBarViews;
  }

  List getBottomAppBarViews(cubit, bool isDark) {
    List bottomAppBarViews = [
      categoriesTabBar(cubit: cubit, isDark: isDark, textData: textData),
      null,
      null,
      null
    ];

    return bottomAppBarViews;
  }

  void changeBottomNavigationBarCurrentIndex(int index) {
    currentBottomNavigationBarIndex = index;
    emit(ChangeBottomNavigationCurrentIndexState());
  }

  void handleSpecialEventsInBottomNavBar(int currentIndex) {
    if (currentIndex == 1) {
      // case of downloaded tab
      readFromDatabase();
    }
  }

  // handle me menu items
  List<Widget> getMeMenuItems({mainApp, cubit}) => [
        meMenuItem(
          title: 'Country',
          icon: Icons.public,
          onPressed: () {},
          isDropDown: true,
          items: countriesList,
          cubit: cubit,
        ),
        meMenuItem(
            title: textData['me-data']?['change-theme'] ?? 'Change Theme',
            icon: Icons.dark_mode,
            onPressed: () {
              mainApp.changeThemeMode();
            },
            isDropDown: false),
        meMenuItem(
            title: textData['me-data']?['language'] ?? 'Change Language',
            icon: Icons.language,
            onPressed: () {
              changeLanguage();
            },
            isDropDown: false,
            actionText: defaultLanguage),
      ];

  void changeLanguage() {
    if (defaultLanguage == 'Arabic') {
      SharedPreferencesHandler.setStringData(
          key: languageKey, value: 'English');
      defaultLanguage = 'English';
    } else {
      SharedPreferencesHandler.setStringData(key: languageKey, value: 'Arabic');
      defaultLanguage = 'Arabic';
    }
    emit(LanguageStringState());
  }

  String? currentCountryCodeString;
  // list of all countries

  List countriesList = CountryHandler.contriesList;

  String? currentCountryString =
      SharedPreferencesHandler.getStringData(key: 'country') ?? 'USA';

  void changeCurrentSelectedCountry(String newCountry) {
    SharedPreferencesHandler.setStringData(key: 'country', value: newCountry);
    currentCountryString = newCountry;
    currentCountryCodeString =
        CountryHandler.getCountryCode(currentCountryString!);
    emit(ChangeCurrentCountryState());
  }

  // handle Search list

  List searchNewsList = [];

  void searchListHandler({required String value}) {
    currentCountryCodeString =
        CountryHandler.getCountryCode(currentCountryString!);
    DioHelper.getData(url: '/v2/everything', queryParameters: {
      'apiKey': apiKey,
      'q': value,
    }).then((value) {
      searchNewsList = value!.data['articles'];
      emit(ReadNewsFromApiSuccessState());
    }).onError((error, stackTrace) {
      apiError = true;
    });
  }

  // handle notifications list

  List notificationNewsList = [];

  bool notificationsLoaded = false;
  bool noNotifications = false;
  void notificationListHandler() {
    DioHelper.getData(url: '/v2/top-headlines', queryParameters: {
      'apiKey': apiKey,
      'country': 'us',
      // 'sortBy': 'publishedAt',
      // 'pageSize': '5',
    }).then((value) {
      notificationsLoaded = true;
      notificationNewsList = value!.data['articles'];
      emit(ReadNewsFromApiSuccessState());
    }).onError((error, stackTrace) {
      apiError = true;
    });
    if (notificationsLoaded == true && notificationNewsList.isEmpty) {
      noNotifications = true;
      emit(EmptyResponseState());
    }
  }

  // handle download news [save news in local database]

  Database? database;

  void initDatabase() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      database = await openDatabase(
        'news.db',
        version: 1,
        onCreate: (db, version) {
          db
              .execute(
                  'CREATE TABLE news(id INTEGER PRIMARY KEY , title TEXT , publisher TEXT , time TEXT , image TEXT , url TEXT)')
              .onError((error, stackTrace) {});
          emit(DatabaseCreateState());
        },
        onOpen: (db) {
          readFromDatabase();
          emit(DatabaseOpenState());
        },
      );
    }
  }

  int viewedNewsListCounter =
      SharedPreferencesHandler.getintData(key: newsCounterKey) ?? 0;

  void incrementViewedNews() {
    if (isRegistered) {
      SharedPreferencesHandler.setIntData(
          key: newsCounterKey, value: ++viewedNewsListCounter);
      viewedNewsListCounter =
          SharedPreferencesHandler.getintData(key: newsCounterKey) ?? 0;
    }
  }

  List<Map<String, Object?>> downloadedNewsList = [];

  bool databaseLoaded = false;
  bool noDownloads = false;
  void readFromDatabase() async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await database
          ?.rawQuery('SELECT * FROM news ORDER BY id DESC')
          .then((value) {
        databaseLoaded = true;
        downloadedNewsList = value;
      });

      if (databaseLoaded == true && downloadedNewsList.isEmpty) {
        noDownloads = true;
      }
    }
    emit(DatabaseReadState());
  }

  void insertToDatabase({required News news}) async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await database!.transaction((txn) {
        return txn.rawInsert(
            'INSERT INTO news(title, publisher, time,  image , url) VALUES("${news.title}" , "${news.author}", "${news.time}" , "${news.image}" ,"${news.url}" )');
      }).then((index) {
        emit(DatabaseInsertState());
        readFromDatabase();
      });
    }
  }

  void insertIntoDatabaseCheck({required News news}) async {
    var data = await database?.rawQuery(
        "SELECT * FROM news WHERE title = '${news.title}' AND  publisher = '${news.author}' AND time = '${news.time}' AND url = '${news.url}'");

    if (data!.isEmpty) {
      insertToDatabase(news: news);
    } else {
      // handle already downloaded
    }
    isDownloadButtonLoading = false;
  }

  void deleteFromDatabase({required News news}) async {
    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      await database?.rawDelete(
          'DELETE FROM news WHERE title = ? AND publisher = ? AND time = ? AND image = ? AND url = ?',
          [news.title, news.author, news.time, news.image, news.url]);
      emit(DatabaseDeleteState());
      readFromDatabase();
    }
  }

  bool isDownloadButtonLoading = false;
  bool isDownloadButtonError = false;

  void handleStorages() async {
    if (await Permission.storage.isGranted == false) {
      Permission.storage.request();
      Permission.accessMediaLocation.request();
      Permission.manageExternalStorage.request();
    }
  }

  Future<String> getImageFromUrl(
      {required String url, required String id}) async {
    var response = await http.get(Uri.parse(url));
    // imageCode = base64.encode(response.bodyBytes);
    imageCode = base64Encode(response.bodyBytes);
    return imageCode;
  }

  String imageCode = 'no image';

  imageHandler(String imageUrl) async {
    String id = imageUrl.split('/').last;
    return await getImageFromUrl(url: imageUrl, id: id);
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("My title"),
      content: const Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // handle user login and register
  get isRegistered =>
      SharedPreferencesHandler.getBooleanData(key: isRegisteredKey) ?? false;

  bool loginScreenEnabled = false;

  void setRegistered(bool isRegistered) {
    SharedPreferencesHandler.setBooleanData(
        key: isRegisteredKey, value: isRegistered);
    emit(UserRegisterdState());
  }

  void showLoginScreen() {
    loginScreenEnabled = true;
    emit(ShowLoginScreenState());
  }

  void hideLoginScreen() {
    loginScreenEnabled = false;
    emit(HideLoginScreenState());
  }

  final ImagePicker picker = ImagePicker();

  String encodedUserImage =
      SharedPreferencesHandler.getStringData(key: userImageKey) ?? '';

  void pickImageFromGallery() async {
    await picker.pickImage(source: ImageSource.gallery).then((imageFile) {
      imageFile!.readAsBytes().then((value) {
        encodedUserImage = base64.encode(value);
      });
    });
    emit(UpdateUserImageState());
  }

  void saveUserImage() {
    SharedPreferencesHandler.setStringData(
        key: userImageKey, value: encodedUserImage);
    emit(UpdateUserImageState());
  }

  Uint8List decodeImage(String encodedImage) {
    return base64.decode(encodedImage);
  }

  String userName = SharedPreferencesHandler.getStringData(key: userNameKey) ??
      'no user name';

  set setName(String name) {
    userName = name;
  }

  void saveUserName() {
    SharedPreferencesHandler.setStringData(key: userNameKey, value: userName);
    emit(UpdateUserNameState());
  }

  void checkRegistered() {
    if (isRegistered) {
      loginScreenEnabled = true;
    }
  }

  String defaultLanguage =
      SharedPreferencesHandler.getStringData(key: languageKey) ?? 'English';

  Map<String, Map<String, String>> textData = {};

  void initLanguage() {
    switch (defaultLanguage) {
      case 'Arabic':
        textData = TextData.arabicTextData;
        break;
      case 'English':
        textData = TextData.englishTextData;
        break;
    }
  }
}
