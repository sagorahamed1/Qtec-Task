abstract class ProductEvent{}


class FetchProduct extends ProductEvent {
  final bool isInitialLoad;
  final String searchQuery;

   FetchProduct({this.isInitialLoad = true, this.searchQuery= ""});

  List<Object> get props => [isInitialLoad];
}


class LoadMoreProducts extends ProductEvent {
   LoadMoreProducts({required String searchQuery});

  List<Object> get props => [];
}

