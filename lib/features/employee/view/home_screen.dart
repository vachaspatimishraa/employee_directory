import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/employee_provider.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_search_bar.dart';
import '../widgets/cached_banner.dart';
import '../widgets/employee_shimmer.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/empty_widget.dart';
import '../../settings/view/settings_bottom_sheet.dart';
import '../../../routes/route_names.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    final showFavorites = _tabController.index == 1;
    ref.read(employeeViewModelProvider.notifier).toggleFavoritesFilter(showFavorites);
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SettingsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Employee Directory',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => _showSettings(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Employees'),
            Tab(text: 'Favorites'),
          ],
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
      ),
      body: Column(
        children: [
          CachedBanner(isVisible: employeeState.isOffline),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: EmployeeSearchBar(
              onChanged: (value) {
                ref.read(employeeViewModelProvider.notifier).searchEmployees(value);
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _AllEmployeesTab(),
                _FavoritesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllEmployeesTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AllEmployeesTab> createState() => _AllEmployeesTabState();
}

class _AllEmployeesTabState extends ConsumerState<_AllEmployeesTab> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      ref.read(employeeViewModelProvider.notifier).managePagination();
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeState = ref.watch(employeeViewModelProvider);

    if (employeeState.isLoading && employeeState.employees.isEmpty) {
      return ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => const EmployeeShimmer(),
      );
    }

    if (employeeState.isError && employeeState.employees.isEmpty) {
      return AppErrorWidget(
        errorMessage: employeeState.errorMessage ?? 'Something went wrong',
        onRetry: () => ref.read(employeeViewModelProvider.notifier).loadEmployees(forceRefresh: true),
      );
    }

    final filtered = employeeState.filteredEmployees;

    if (filtered.isEmpty) {
      return const EmptyWidget(
        title: 'No Employees Found',
        description: 'Try searching for another name or email.',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(employeeViewModelProvider.notifier).refreshEmployees(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filtered.length + (employeeState.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == filtered.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
            );
          }

          final employee = filtered[index];
          return EmployeeCard(
            employee: employee,
            onTap: () => context.push(RouteNames.employeeDetail, extra: employee.id),
            onFavoriteTap: () => ref.read(employeeViewModelProvider.notifier).toggleFavorite(employee.id),
          );
        },
      ),
    );
  }
}

class _FavoritesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeState = ref.watch(employeeViewModelProvider);
    final filtered = employeeState.filteredEmployees;

    if (filtered.isEmpty) {
      return const EmptyWidget(
        title: 'No Favorites Found',
        description: 'Mark employees as favorite to see them here.',
        icon: Icons.favorite_border_rounded,
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final employee = filtered[index];
        return EmployeeCard(
          employee: employee,
          onTap: () => context.push(RouteNames.employeeDetail, extra: employee.id),
          onFavoriteTap: () => ref.read(employeeViewModelProvider.notifier).toggleFavorite(employee.id),
        );
      },
    );
  }
}
