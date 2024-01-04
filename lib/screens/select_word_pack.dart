import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flash_minds/backend/models/game_progress.dart';
import 'package:flash_minds/backend/models/wordpack.dart';
import 'package:flash_minds/backend/services/api.dart';
import 'package:flash_minds/backend/services/app_state.dart';
import 'package:flash_minds/utils/constants.dart';
import 'package:flash_minds/widgets/components/button.dart';
import 'package:flash_minds/widgets/components/cached_or_asset_image.dart';
import 'package:flash_minds/widgets/components/selectable_item.dart';

class SelectWordpack extends StatefulWidget {
  const SelectWordpack({super.key});

  @override
  State<SelectWordpack> createState() => _SelectWordpackState();
}

class _SelectWordpackState extends State<SelectWordpack> {
  AppStateService appState = Get.find<AppStateService>();
  RoundedLoadingButtonController controller = RoundedLoadingButtonController();
  GameProgress? progress;

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool loaded = false;
  int minRating = 1, maxRating = 5;
  WordPack? selectedWordpack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: _appBar,
      body: _body,
      floatingActionButton: _floatingActionButton,
      endDrawer: _filterDrawer,
      bottomNavigationBar:
          selectedWordpack != null ? _bottomNavigationBar : null,
      extendBody: true,
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text('Select your word pack'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _key.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget get _body {
    return FutureBuilder(
      future: loaded ? null : Api.getWordPacks(),
      builder: (context, AsyncSnapshot<List<WordPack>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<WordPack> wordPacks = snapshot.data as List<WordPack>;
        loaded = true;
        return ListView.builder(
          itemCount: wordPacks.length,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
          itemBuilder: (context, index) {
            WordPack wordPack = wordPacks[index];
            return SelectableItem(
              text: wordPack.name,
              subtitle: '${wordPack.words.length} words',
              color: Theme.of(context).primaryColor,
              leading: CachedOrAssetImage(wordPack.image),
              middle: Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  children: wordPack.languages
                      .map(
                        (e) => Image.asset('assets/flags/$e.png', width: 24),
                      )
                      .toList()
                      .reversed
                      .toList(),
                ),
              ),
              trailing: Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index + 1 <= wordPack.rating
                        ? Icons.star_rounded
                        : index + .5 < wordPack.rating
                            ? Icons.star_half_rounded
                            : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 16,
                  ),
                ),
              ),
              onTap: () => setState(() => selectedWordpack = wordPack),
              selected: selectedWordpack?.id == wordPack.id,
            );
          },
        );
      },
    );
  }

  Widget get _floatingActionButton {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, Routes.createWordpack),
      child: const Icon(Icons.add),
    );
  }

  Widget get _bottomNavigationBar {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Button(
        controller: controller,
        onPressed: () async {
          controller.start();
          controller.success();
          await Future.delayed(const Duration(milliseconds: 300));

          if (!mounted) return;
          // Navigator.pushNamed(
          //   context,
          //   Routes.game,
          //   arguments: {
          //     StorageKeys.wordPacks: selectedWordpack,
          //     'progress': progress,
          //   },
          // ).then((p) {
          //   controller.reset();
          //   progress = p as GameProgress?;
          // });
        },
        text: 'Play',
      ),
    );
  }

  Drawer get _filterDrawer {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Filter Word Packs',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Rating'),
          ),
          ListTile(
            title: const Text('Minimum'),
            trailing: DropdownButton<int>(
              value: minRating,
              onChanged: (value) {
                setState(() {
                  minRating = value!;
                });
              },
              items: List.generate(
                5,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  enabled: i < maxRating,
                  child: Row(
                    children: List.generate(
                      5,
                      (j) => Icon(
                        j <= i ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Maximum'),
            trailing: DropdownButton<int>(
              value: maxRating,
              onChanged: (value) {
                setState(() {
                  maxRating = value!;
                });
              },
              items: List.generate(
                5,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  enabled: i + 1 >= minRating,
                  child: Row(
                    children: List.generate(
                      5,
                      (j) => Icon(
                        j <= i ? Icons.star_rounded : Icons.star_border_rounded,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Button(
              onPressed: () {
                setState(() {
                  selectedWordpack = null;
                  Navigator.pop(context);
                });
              },
              text: 'Apply',
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                selectedWordpack = null;
                minRating = 1;
                maxRating = 5;
                Navigator.pop(context, true);
              });
            },
            child: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}
