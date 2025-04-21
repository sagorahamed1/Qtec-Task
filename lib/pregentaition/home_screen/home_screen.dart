import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/product/product_bloc.dart';
import '../../bloc/product/product_event.dart';
import '../../bloc/product/product_state.dart';
import '../../models/product_model.dart';
import 'inner_widgets/product_card.dart';
import 'inner_widgets/product_card_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;

    return Scaffold(

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.04),


            ///<<<===============>>> HEADER SEARCH BAR <<<==================>>>

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by name',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: _onSearchChanged,
                    ),
                  ),
                  const SizedBox(width: 8),


                  ///<<<===============>>> ASC AND DES <<<==================>>>


                  IconButton(
                    icon: Text(
                      _isAscend ? 'ASC' : 'DES',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: _sortProductsByPrice,
                  ),
                ],
              ),
            ),


            ///<<<===============>>> SHOW PRODUCTS <<<==================>>>

            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {

                  ///================== LOADING====================>>>>

                  if (state is ProductInitState || state is ProductLoadingState) {
                    return _buildShimmerLoader(screenWidth);


                    ///================ERROR HANDLE======================>>>

                  } else if (state is ProductErrorState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.errorMessage),
                          SizedBox(height: screenHeight * 0.02),
                          ElevatedButton(
                            onPressed: _loadInitialProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );


                    ///=================== PRODUCT LOADED ===================>

                  } else if (state is ProductLoadedState) {
                    _filteredProducts = state.products;
                    if (_searchQuery.isNotEmpty) {
                      _filteredProducts = _filterProducts(_searchQuery);
                    }
                    return _buildProductGrid(state, screenWidth);
                  }
                  return const Center(child: Text('Unknown state'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  ///===================== SHIMMER LOADER ======================>>>


  Widget _buildShimmerLoader(double screenWidth) {
    final crossAxisCount = screenWidth ~/ 180;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(screenWidth * 0.04),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount > 1 ? crossAxisCount : 1,
        crossAxisSpacing: screenWidth * 0.04,
        mainAxisSpacing: screenWidth * 0.04,
        childAspectRatio: 0.75,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const ProductCardShimmer(),
        );
      },
    );
  }


  ///===================== PRODUCT GRID ==========================>>>>

  Widget _buildProductGrid(ProductLoadedState state, double screenWidth) {
    final crossAxisCount = screenWidth ~/ 180;

    return RefreshIndicator(
      onRefresh: () async {
        _loadInitialProducts();
      },
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(screenWidth * 0.04),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount > 1 ? crossAxisCount : 1,
          crossAxisSpacing: screenWidth * 0.04,
          mainAxisSpacing: screenWidth * 0.04,
          childAspectRatio: 0.6639,
        ),
        itemCount: state.hasReachedMax
            ? _filteredProducts.length
            : _filteredProducts.length + 1,
        itemBuilder: (context, index) {
          if (index >= _filteredProducts.length) {
            return state.isLoadingMore
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }
          return ProductCard(product: _filteredProducts[index]);
        },
      ),
    );
  }





  String _searchQuery = '';
  bool _isAscend = true;

  List<ProductModel> _filteredProducts = [];

  void _loadInitialProducts() {
    context.read<ProductBloc>().add(FetchProduct(
      isInitialLoad: true,
      searchQuery: _searchQuery,
    ));
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductBloc>().add(LoadMoreProducts(searchQuery: _searchQuery));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredProducts = _filterProducts(query);
    });
  }

  List<ProductModel> _filterProducts(String query) {
    return _filteredProducts
        .where((product) => product.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  void _sortProductsByPrice() {
    setState(() {
      if (_isAscend) {
        _filteredProducts.sort((a, b) => a.price!.compareTo(b.price!));
      } else {
        _filteredProducts.sort((a, b) => b.price!.compareTo(a.price!));
      }
      _isAscend = !_isAscend;
    });
  }


}




