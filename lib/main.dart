import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_dashboard/core/routes/app_route.dart';
import 'package:product_dashboard/core/theme/theme.cubit.dart';
import 'package:product_dashboard/core/theme/app_theme.dart';
import 'package:product_dashboard/features/product/data/datasources/product_local_data_source.dart';
import 'package:product_dashboard/features/product/data/repositories/product.repository_impl.dart';
import 'package:product_dashboard/features/product/presentation/blocs/product_cubit.dart';

void main() {
  runApp(const ProductDashboardApp());
}

class ProductDashboardApp extends StatelessWidget {
  const ProductDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) => ProductCubit(
            ProductRepositoryImpl(ProductLocalDataSource()),
          )..fetchProducts(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Product Dashboard',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
