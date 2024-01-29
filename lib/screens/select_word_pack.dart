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
      body: _WordPackList(
        selectedWordpack: selectedWordpack,
        onTap: (wordPack) {
          setState(() {
            selectedWordpack = wordPack;
          });
        },
      ),
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
          Navigator.pushNamed(
            context,
            Routes.flashCards,
            arguments: selectedWordpack,
          ).then((_) => controller.reset());
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

class _WordPackList extends StatefulWidget {
  const _WordPackList({
    required this.selectedWordpack,
    required this.onTap,
  });
  final WordPack? selectedWordpack;
  final Function(WordPack) onTap;

  @override
  State<_WordPackList> createState() => __WordPackListState();
}

class __WordPackListState extends State<_WordPackList> {
  ScrollController scrollController = ScrollController();
  List<WordPack>? wordPacks;
  int currentPage = 0;
  bool hasMore = true;
  bool loading = false;

  Future<void> loadWordPacks({int? page}) async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    List<WordPack> response = await Api.getWordPacks(page: page ?? 0);
    hasMore = response.length == 10 && response.last.id > 0;
    setState(() {
      wordPacks ??= [];
      wordPacks!.addAll(response);
      currentPage++;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadWordPacks();
    scrollController.addListener(() {
      if (hasMore &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        loadWordPacks(page: currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return wordPacks == null
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: wordPacks!.length,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemBuilder: (context, index) {
                    WordPack wordPack = wordPacks![index];
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
                                (e) => Image.asset(
                                  'assets/flags/$e.png',
                                  width: 24,
                                ),
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
                      onTap: () => widget.onTap.call(wordPack),
                      selected: widget.selectedWordpack?.id == wordPack.id,
                    );
                  },
                ),
              ),
              if (loading) const LinearProgressIndicator(),
            ],
          );
  }
}
