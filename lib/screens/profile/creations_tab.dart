import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
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
          return ListView.builder(
            itemCount: boughtWordpacks.data?.length,
            itemBuilder: (context, index) {
              WordPack wordPack = boughtWordpacks.data![index];
              return ListTile(
                title: Text(wordPack.name, style: TextStyles.h4),
                subtitle: Text('${wordPack.words.length} words'),
                leading: CachedOrAssetImage(wordPack.image),
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
