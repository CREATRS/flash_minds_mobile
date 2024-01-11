import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/screens/profile/word_pack_form.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';

class CreationsTab extends StatelessWidget {
  const CreationsTab(this.myWordPacks, {super.key, required this.refresh});

  final List<WordPack> myWordPacks;
  final void Function(void Function()) refresh;

  Future<void> onTap(WordPack? wordPack) async {
    bool? shouldRefresh = await Get.bottomSheet<bool?>(
      WordPackForm(wordPack: wordPack),
      isScrollControlled: true,
    );
    if (shouldRefresh ?? false) {
      refresh(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myWordPacks.isEmpty
          ? const Center(
              child: Text(
                'You have not created any wordpacks yet.',
                style: TextStyles.pMedium,
              ),
            )
          : ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: myWordPacks.length,
              itemBuilder: (context, index) {
                WordPack wordPack = myWordPacks[index];
                return ListTile(
                  leading: CachedOrAssetImage(wordPack.image),
                  title: Text(wordPack.name, style: TextStyles.h4),
                  subtitle: Text('${wordPack.words.length} words'),
                  onTap: () => onTap(wordPack),
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onTap(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
