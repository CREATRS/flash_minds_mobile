class ObjectResponse<T> {
  const ObjectResponse({
    required this.success,
    this.object,
    this.errors,
  });

  final bool success;
  final T? object;
  final List? errors;

  bool get hasErrors => (errors ?? []).isNotEmpty;
}
