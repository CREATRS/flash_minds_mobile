import 'package:flutter/material.dart';

import 'package:flash_minds/utils/constants.dart';

class PaginatedListView<T> extends StatefulWidget {
  const PaginatedListView({
    super.key,
    required this.itemBuilder,
    required this.future,
    this.validation,
    this.onEmpty = 'No items found.',
  });
  final Widget Function(T) itemBuilder;
  final Future<List<T>> Function({int page}) future;
  final bool Function(List<T>)? validation;
  final String onEmpty;

  @override
  State<PaginatedListView> createState() => _PaginatedListViewState();
}

class _PaginatedListViewState<T> extends State<PaginatedListView> {
  ScrollController scrollController = ScrollController();
  List<T>? data;
  int currentPage = 0;
  bool hasMore = true;
  bool loading = false;

  Future<void> loadData({int? page}) async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    List<T> response = await widget.future.call(page: page ?? 0) as List<T>;
    hasMore =
        response.length == 10 && (widget.validation?.call(response) ?? true);
    data ??= [];
    setState(() {
      data!.addAll(response);
      currentPage++;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
    scrollController.addListener(() {
      if (hasMore &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        loadData(page: currentPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return const Center(child: CircularProgressIndicator());
    if (data!.isEmpty) {
      return Center(child: Text(widget.onEmpty, style: TextStyles.pMedium));
    }
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
            itemCount: data!.length,
            itemBuilder: (context, index) => widget.itemBuilder(data![index]),
          ),
        ),
        if (loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: LinearProgressIndicator(),
          ),
      ],
    );
  }
}
