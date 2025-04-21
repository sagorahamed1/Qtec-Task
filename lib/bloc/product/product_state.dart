

import 'package:task/models/product_model.dart';

abstract class ProductState{}

///<<<===============>>> PRODUCTS INIT  <<<==================>>>

class ProductInitState extends ProductState{}

///<<<===============>>>  PRODUCTS LOADING <<<==================>>>

class ProductLoadingState extends ProductState{}


///<<<===============>>> PRODUCT LOADED <<<==================>>>

class ProductLoadedState extends ProductState {
  final List<ProductModel> products;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final String? errorMessage;

   ProductLoadedState({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  ProductLoadedState copyWith({
    List<ProductModel>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return ProductLoadedState(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  List<Object> get props => [products, hasReachedMax, isLoadingMore];
}


///<<<===============>>> PRODUCTS ERROR <<<==================>>>

class ProductErrorState extends ProductState{
  String errorMessage;
  ProductErrorState(this.errorMessage);
}