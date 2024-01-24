import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/screens/profile/word_pack_form.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/word_pack_list_tile.dart';

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
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: myWordPacks.length,
              itemBuilder: (context, index) {
                return WordPackListTile(myWordPacks[index], onTap: onTap);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onTap(null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
