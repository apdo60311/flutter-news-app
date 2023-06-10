import 'package:flutter/material.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';

import '../../main.dart';
import '../../shared/components/constants.dart';
import '../../shared/styles/colors.dart';

class MePage extends StatelessWidget {
  MePage({super.key, required this.cubit});
  final AppCubit cubit;

  final TextEditingController usernameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var mainApp = MyApp.of(context);
    cubit.checkRegistered();
    return SingleChildScrollView(
      child: Directionality(
        textDirection: (cubit.defaultLanguage == 'Arabic')
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            Flexible(
              flex: 4,
              child: Center(
                child: (cubit.loginScreenEnabled)
                    ? Column(
                        children: [
                          CircleAvatar(
                            minRadius: 50.0,
                            maxRadius: 60.0,
                            backgroundColor: circularAvatarColor,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: (cubit.isRegistered)
                                  ? ClipOval(
                                      child: Image.memory(
                                        cubit.decodeImage(
                                            cubit.encodedUserImage),
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                          Image.asset('assets/images/logo.png'),
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(60.0),
                                            ),
                                            child: IconButton(
                                              onPressed: () async {
                                                cubit.pickImageFromGallery();
                                              },
                                              icon: const Icon(
                                                Icons.photo_camera_outlined,
                                              ),
                                              iconSize: 30,
                                              color: Colors.pink,
                                            ),
                                          )
                                        ]),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          (cubit.isRegistered)
                              ? Text(
                                  cubit.userName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: TextField(
                                    onTapOutside: (event) {
                                      if (usernameController.text.isNotEmpty) {
                                        cubit.setName = usernameController.text;
                                      }
                                    },
                                    controller: usernameController,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        hintText: cubit.textData['me-data']
                                            ?['usernameHintText'],
                                        hintStyle: TextStyle(
                                            color: usernameFieldHintTextColor)),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: usernameFieldSize,
                                    ),
                                  ),
                                ),
                          (cubit.isRegistered == false)
                              ? TextButton(
                                  onPressed: () {
                                    cubit.saveUserImage();
                                    cubit.saveUserName();
                                    cubit.setRegistered(true);
                                  },
                                  child: Text(cubit.textData['me-data']
                                          ?['saveButton'] ??
                                      'save'))
                              : const Text(''),
                        ],
                      )
                    : Center(
                        child: TextButton(
                            onPressed: () {
                              cubit.showLoginScreen();
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.login_rounded,
                                  size: 28,
                                  color: Colors.pink,
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  cubit.textData['me-data']?['LoginButton'] ??
                                      'Login',
                                  style: const TextStyle(fontSize: 18),
                                )
                              ],
                            )),
                      ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.0, color: Colors.grey),
                    bottom: BorderSide(width: 2.0, color: Colors.grey),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    rowItem(
                        icon: Icons.favorite,
                        text: cubit.downloadedNewsList.length.toString()),
                    rowItem(
                        icon: Icons.remove_red_eye,
                        text: cubit.viewedNewsListCounter.toString()),
                    rowItem(
                        icon: Icons.notifications,
                        text: cubit.notificationNewsList.length.toString()),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 60.0,
            ),
            Flexible(
              flex: 2,
              child: Column(
                children: cubit.getMeMenuItems(mainApp: mainApp, cubit: cubit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row rowItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: Colors.pink),
        const SizedBox(width: 5.0),
        Text(text),
      ],
    );
  }
}
