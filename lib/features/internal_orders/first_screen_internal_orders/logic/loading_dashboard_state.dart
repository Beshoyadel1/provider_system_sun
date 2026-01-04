class InternalOrdersState {
  final bool isLoading;
  final bool isLoaded;
  InternalOrdersState({this.isLoading = false, this.isLoaded = false});

  InternalOrdersState copyWith({
    bool? isLoading,
    bool? isLoaded,
  }) {
    return InternalOrdersState(
      isLoading: isLoading ?? this.isLoading,
      isLoaded: isLoaded ?? this.isLoaded,
    );
  }
}
