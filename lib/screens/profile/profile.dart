import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/screens/profile/creations_tab.dart';
import 'package:flash_minds/screens/profile/learning_tab.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthService>(
      builder: (auth) {
        User? user = auth.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }
        Widget picture = user.avatar != null
            ? Image.network(user.avatar!, fit: BoxFit.fitWidth)
            : const AppIcon(height: 200);
        return DefaultTabController(
          length: 2,
          child: FutureBuilder(
            future: Api.getProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'There was an error trying to load your word packs.\n\n',
                      style: TextStyles.pMedium,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: const Text('Refresh'),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      child: const Text('Go back'),
                    ),
                  ],
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.width - 24,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            user.name,
                            style: TextStyles.h3.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyles.pSmall.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      titlePadding: EdgeInsets.zero,
                      background: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(color: Colors.black38),
                          picture,
                          BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: user.avatar == null
                                  ? AppColors.lightRed.withOpacity(.5)
                                  : null,
                              child: ClipOval(child: picture),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return TabBar(
                          tabs: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.progress.length.toString(),
                                ),
                                const Text('Learning'),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.wordPacksCount.toString(),
                                ),
                                const Text('Creations'),
                              ],
                            ),
                          ],
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelStyle: TextStyles.pMedium,
                        );
                      },
                      childCount: 1,
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      children: [
                        LearningTab(auth.user.value!.progress),
                        CreationsTab(refresh: setState),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
