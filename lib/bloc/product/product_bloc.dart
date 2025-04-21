
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/product/product_event.dart';
import 'package:task/bloc/product/product_state.dart';
import 'package:task/helpers/dio_data_provider.dart';
import 'package:task/models/product_model.dart';



class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final DioDataProvider dataProvider;
  int page = 1;
  final int limit = 10;
  bool hasReachedMax = false;

  ProductBloc({required this.dataProvider}) : super(ProductInitState()) {
    on<FetchProduct>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }


  ///<<<===============>>> FETCH PRODUCTS <<<==================>>>

  Future<void> _onFetchProducts(
      FetchProduct event,
      Emitter<ProductState> emit,
      ) async {
    if (event.isInitialLoad) {
      emit(ProductLoadingState());
      page = 1;
      hasReachedMax = false;
    }

    try {
      final response = await dataProvider.getDataProvider(
        '/products?limit=$limit&page=$page&search=${event.searchQuery}',
      );

      if (response.statusCode == 200) {
        final data = List<ProductModel>.from(
          response.data.map((x) => ProductModel.fromJson(x)),
        );

        emit(ProductLoadedState(
          products: data,
          hasReachedMax: data.length < limit,
        ));
      } else {
        emit(ProductErrorState("Failed to load products"));
      }
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }



  ///<<<===============>>> LOAD MORE PRODUCTS <<<==================>>>


  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event,
      Emitter<ProductState> emit,
      ) async {
    if (hasReachedMax) return;

    page++;
    emit((state as ProductLoadedState).copyWith(isLoadingMore: true));

    try {
      final response = await dataProvider.getDataProvider(
        '/products?limit=$limit&page=$page',
      );

      if (response.statusCode == 200) {
        final data = List<ProductModel>.from(
          response.data.map((x) => ProductModel.fromJson(x)),
        );

        hasReachedMax = data.length < limit;

        emit(ProductLoadedState(
          products: [...(state as ProductLoadedState).products, ...data],
          hasReachedMax: hasReachedMax,
        ));
      } else {
        page--; // Revert page increment on failure
        emit((state as ProductLoadedState).copyWith(
          isLoadingMore: false,
          errorMessage: "Failed to load more products",
        ));
      }
    } catch (e) {
      page--; // Revert page increment on failure
      emit((state as ProductLoadedState).copyWith(
        isLoadingMore: false,
        errorMessage: e.toString(),
      ));
    }
  }
}