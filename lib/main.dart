import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/product/product_bloc.dart';
import 'package:task/pregentaition/home_screen/home_screen.dart';

import 'helpers/dio_data_provider.dart';
import 'helpers/dio_helper.dart';

void main() {
  DioHelper.init(baseUrl: "https://fakestoreapi.com");
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductBloc(dataProvider: DioDataProvider(dio: DioHelper.dio)))
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task',
      home: HomeScreen()
    );
  }
}
