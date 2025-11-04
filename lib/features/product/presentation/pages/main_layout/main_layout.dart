
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_dashboard/core/theme/theme.cubit.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: colorScheme.surfaceVariant,
            selectedIndex: _getSelectedIndex(context),
            onDestinationSelected: (index) {
              switch (index) {
                case 0:
                  context.go('/dashboard');
                  break;
                case 1:
                  context.go('/');
                  break;
                case 2:
                  context.go('/settings');
                  break;
              }
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Products'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                // Container(
                //   height: 64,
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   color: colorScheme.surface,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                    
                //       Row(
                //         children: [
                //           IconButton(
                //             tooltip: 'Toggle Light/Dark',
                //             icon: Icon(
                //               Theme.of(context).brightness == Brightness.dark
                //                   ? Icons.light_mode_outlined
                //                   : Icons.dark_mode_outlined,
                //             ),
                //             onPressed: () =>
                //                 context.read<ThemeCubit>().toggleTheme(),
                //           ),
                //           const SizedBox(width: 10),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/dashboard')) return 0;
    if (location.startsWith('/settings')) return 2;
    return 1;
  }
}
