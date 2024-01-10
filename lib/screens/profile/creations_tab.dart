import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/screens/profile/word_pack_form.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';

class CreationsTab extends StatelessWidget {
  const CreationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Api.getWordPacks(me: true),
        builder: (context, boughtWordpacks) {
          if (!boughtWordpacks.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (boughtWordpacks.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have not created any wordpacks yet.',
                style: TextStyles.pMedium,
              ),
            );
          }
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: boughtWordpacks.data?.length,
            itemBuilder: (context, index) {
              WordPack wordPack = boughtWordpacks.data![index];
              return ListTile(
                leading: CachedOrAssetImage(wordPack.image),
                title: Text(wordPack.name, style: TextStyles.h4),
                subtitle: Text('${wordPack.words.length} words'),
                onTap: () => Get.bottomSheet(
                  WordPackForm(wordPack: wordPack),
                  isScrollControlled: true,
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          wordPack.rating.toString(),
                          style: TextStyles.pMedium,
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          wordPack.rating > 4
                              ? Icons.star
                              : wordPack.rating > 2
                                  ? Icons.star_half
                                  : Icons.star_border,
                          size: 20,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                    Text('${(wordPack.rating * 10).toInt()} reviews'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(
          const WordPackForm(),
          isScrollControlled: true,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
