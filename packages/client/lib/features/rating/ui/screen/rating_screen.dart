import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/context/ui/bloc/context_cubit.dart';
import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/rating_cubit.dart';
import '../widget/rating_list_tile.dart';

@RoutePage()
class RatingScreen extends StatelessWidget implements AutoRouteWrapper {
  const RatingScreen({super.key});

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => RatingCubit(),
          ),
          BlocProvider(
            create: (_) => ContextCubit(),
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ContextCubit, ContextState>(
              listenWhen: (p, c) => p.selected != c.selected,
              listener: (context, state) =>
                  context.read<RatingCubit>().fetch(state.selected),
            ),
            const BlocListener<RatingCubit, RatingState>(
              listener: commonScreenBlocListener,
            ),
          ],
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RatingCubit>();
    return BlocBuilder<RatingCubit, RatingState>(
      buildWhen: (p, c) => c.isSuccess || c.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final filter = state.searchFilter;
        final items = filter.isEmpty
            ? state.items
            : state.items
                .where(
                    (e) => e.title.toLowerCase().contains(filter.toLowerCase()))
                .toList();

        return Scaffold(
          appBar: AppBar(
            actions: [
              // Clear input
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                icon: const Icon(Icons.clear_rounded),
                onPressed: filter.isEmpty ? null : cubit.clearSearchFilter,
              ),

              // Toggle sorting by value
              IconButton(
                onPressed: cubit.toggleSortingByAsc,
                icon: state.isSortedByAsc
                    ? const Icon(Icons.keyboard_arrow_up_rounded)
                    : const Icon(Icons.keyboard_arrow_down_rounded),
              ),

              // Toggle sorting by ego
              IconButton(
                onPressed: cubit.toggleSortingByEgo,
                icon: state.isSortedByEgo
                    ? const Icon(Icons.keyboard_arrow_right_rounded)
                    : const Icon(Icons.keyboard_arrow_left_rounded),
              ),
            ],

            title: Row(
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.only(right: kSpacingLarge),
                  child: Text('Rating'),
                ),

                // Search Input
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Search by',
                      isCollapsed: true,
                      isDense: true,
                    ),
                    initialValue: state.searchFilter,
                    onChanged: cubit.setSearchFilter,
                    textInputAction: TextInputAction.go,
                  ),
                ),
              ],
            ),

            // Context selector
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: Padding(
                padding: kPaddingH,
                child: ContextDropDown(
                  key: Key('RatingContextSelector'),
                ),
              ),
            ),
          ),

          // Rating List
          body: ListView.separated(
            padding: kPaddingH,
            itemCount: items.length,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) => RatingListTile(
              key: ValueKey(items[i]),
              isDarkMode: isDarkMode,
              profile: items[i],
            ),
          ),
        );
      },
    );
  }
}
