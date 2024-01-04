import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/user.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/backend/services/auth.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/app_icon.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
            : const AppIcon(height: 200, padding: EdgeInsets.all(8));
        return DefaultTabController(
          length: 3,
          child: FutureBuilder(
            future: Api.getWordPacks(me: true),
            builder: (context, boughtWordpacks) {
              if (!boughtWordpacks.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                    clipBehavior: Clip.hardEdge,
                    height: MediaQuery.of(context).size.width - 24,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(color: Colors.black38),
                        picture,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                              child: CircleAvatar(
                                radius: 72,
                                backgroundColor:
                                    user.avatar == null ? Colors.white : null,
                                child: ClipOval(child: picture),
                              ),
                            ),
                            Text(
                              user.name,
                              style:
                                  TextStyles.h2.copyWith(color: Colors.white),
                            ),
                            Text(
                              user.email,
                              style: TextStyles.pMedium
                                  .copyWith(color: Colors.white),
                            ),
                            const Spacer(),
                            TabBar(
                              tabs: [
                                const Text('Account'),
                                Column(
                                  children: [
                                    Text(
                                      boughtWordpacks.data!.length.toString(),
                                    ),
                                    const Text('Learning'),
                                  ],
                                ),
                                const Column(
                                  children: [
                                    Text('10'),
                                    Text('Creations'),
                                  ],
                                ),
                              ],
                              indicatorWeight: 3,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: TextStyles.pMedium,
                              unselectedLabelColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        const Icon(Icons.person_outlined, size: 100),
                        ListView.builder(
                          itemCount: boughtWordpacks.data!.length,
                          itemBuilder: (context, index) {
                            WordPack wordpack = boughtWordpacks.data![index];
                            return ListTile(
                              title: Text(wordpack.name),
                              subtitle: Text(
                                wordpack.words.map((e) => e).join(', '),
                              ),
                              leading: CachedOrAssetImage(wordpack.image),
                              trailing: Text(
                                wordpack.rating.toString(),
                                style: TextStyles.pMedium,
                              ),
                            );
                          },
                        ),
                        const Text('My creations', style: TextStyles.h1),
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
