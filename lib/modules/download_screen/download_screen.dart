import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsapp/shared/cubit/cubit_states.dart';
import 'package:newsapp/shared/cubit/news_cubit.dart';

import '../../shared/components/components.dart';

class DownloadScreen extends StatelessWidget {
  const DownloadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      builder: (BuildContext context, state) {
        AppCubit cubit = AppCubit.get(context);
        return (cubit.noDownloads == false)
            ? (cubit.downloadedNewsList.isNotEmpty)
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      listOfDownloadedNews(
                        count: cubit.downloadedNewsList.length,
                        data: cubit.downloadedNewsList,
                        isError: false,
                        cubit: cubit,
                      ),
                    ],
                  )
                : loadingEffect()
            : noDownloadsHint();
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
