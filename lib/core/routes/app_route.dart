import 'package:go_router/go_router.dart';
import 'package:product_dashboard/features/product/presentation/pages/dashboardpages/dashbaord_page.dart';
import 'package:product_dashboard/features/product/presentation/pages/main_layout/main_layout.dart';
import 'package:product_dashboard/features/product/presentation/pages/productpages/product_detail_page.dart';
import 'package:product_dashboard/features/product/presentation/pages/productpages/product_list_page.dart';
import 'package:product_dashboard/features/product/presentation/pages/settingpages/setting_page.dart';


final GoRouter appRouter = GoRouter(
  routes: [
   
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductListPage(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return ProductDetailPage(productId: id);
          },
        ),
      ],
    ),
  ],
);
