import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/shared/cubit/cubit_states.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';

import '../../shared/components/components.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      builder: (BuildContext context, state) {
        AppCubit cubit = AppCubit.get(context);

        return (cubit.noNotifications == false)
            ? (cubit.notificationNewsList.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      listOfNotificationNews(
                        count: cubit.notificationNewsList.length,
                        data: cubit.notificationNewsList,
                        isError: false,
                        cubit: cubit,
                      ),
                    ],
                  )
                : loadingEffect()
            : noNotificationHint();
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
