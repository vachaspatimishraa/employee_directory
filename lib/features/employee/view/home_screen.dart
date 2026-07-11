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
import 'add_employee_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    final showFavorites = index == 1;
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
        leading: IconButton(
          icon: const Icon(Icons.account_circle_rounded),
          onPressed: () => context.push(RouteNames.adminProfile),
        ),
        title: Text(
          _selectedIndex == 2 ? 'Add Employee' : 'Employee Directory',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedIndex != 2) CachedBanner(isVisible: employeeState.isOffline),
          if (_selectedIndex != 2)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: EmployeeSearchBar(
                onChanged: (value) {
                  ref.read(employeeViewModelProvider.notifier).searchEmployees(value);
                },
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                _EmployeesListTab(isFavorites: false),
                _EmployeesListTab(isFavorites: true),
                AddEmployeeScreen(
                  onSaved: () => _onItemTapped(0),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'All',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_outlined),
            selectedIcon: Icon(Icons.person_add),
            label: 'Add',
          ),
        ],
      ),
    );
  }
}

class _EmployeesListTab extends ConsumerStatefulWidget {
  final bool isFavorites;
  const _EmployeesListTab({required this.isFavorites});

  @override
  ConsumerState<_EmployeesListTab> createState() => _EmployeesListTabState();
}

class _EmployeesListTabState extends ConsumerState<_EmployeesListTab> {
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
    if (!widget.isFavorites && _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
      ref.read(employeeViewModelProvider.notifier).managePagination();
    }
  }

  Future<void> _deleteEmployee(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(employeeViewModelProvider.notifier).deleteEmployee(id);
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
      return EmptyWidget(
        title: widget.isFavorites ? 'No Favorites Found' : 'No Employees Found',
        description: widget.isFavorites 
            ? 'Mark employees as favorite to see them here.' 
            : 'Try searching for another name or email.',
        icon: widget.isFavorites ? Icons.favorite_border_rounded : Icons.search_off_rounded,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(employeeViewModelProvider.notifier).refreshEmployees(),
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: filtered.length + (!widget.isFavorites && employeeState.hasMoreData ? 1 : 0),
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
          return GestureDetector(
            onLongPress: () => _deleteEmployee(employee.id),
            child: EmployeeCard(
              employee: employee,
              onTap: () => context.push(RouteNames.employeeDetail, extra: employee),
              onFavoriteTap: () => ref.read(employeeViewModelProvider.notifier).toggleFavorite(employee.id),
            ),
          );
        },
      ),
    );
  }
}
