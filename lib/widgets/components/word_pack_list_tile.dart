import 'package:flutter/material.dart';

import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/utils/constants.dart';
import 'cached_or_asset_image.dart';

class WordPackListTile extends StatelessWidget {
  const WordPackListTile(this.wordPack, {super.key, this.trailing, this.onTap});
  final WordPack wordPack;
  final Widget? trailing;
  final void Function(WordPack)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedOrAssetImage(wordPack.image),
      title: Text(wordPack.name, style: TextStyles.h4),
      subtitle: Text('${wordPack.words.length} words'),
      onTap: onTap != null ? () => onTap!.call(wordPack) : null,
      trailing: trailing ??
          Column(
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
  }
}
