import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../bloc/rating_cubit.dart';
import '../widget/rating_list_tile.dart';

@RoutePage()
class RatingScreen extends StatefulWidget implements AutoRouteWrapper {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (_) => RatingCubit(),
        child: this,
      );
}

class _RatingScreenState extends State<RatingScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  late final _cubit = context.read<RatingCubit>();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [
            // Search Input
            TextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search by',
                isDense: true,
                isCollapsed: true,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                constraints: BoxConstraints.tightForFinite(
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
              textAlign: TextAlign.end,
              textInputAction: TextInputAction.go,
              onChanged: _cubit.setSearchFilter,
              onTapOutside: (_) => _searchFocusNode.unfocus(),
            ),

            // Clear input
            BlocBuilder<RatingCubit, RatingState>(
              buildWhen: (p, c) =>
                  p.searchFilter.isEmpty || c.searchFilter.isEmpty,
              builder: (context, s) => IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                icon: const Icon(Icons.clear_rounded),
                onPressed: s.searchFilter.isEmpty
                    ? null
                    : () {
                        _searchController.clear();
                        _cubit.clearSearchFilter();
                      },
              ),
            ),

            // Toggle sorting by value
            BlocBuilder<RatingCubit, RatingState>(
              buildWhen: (p, c) => p.isSortedByAsc != c.isSortedByAsc,
              builder: (context, state) => IconButton(
                onPressed: _cubit.toggleSortingByAsc,
                icon: state.isSortedByAsc
                    ? const Icon(Icons.keyboard_arrow_up_rounded)
                    : const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            ),

            // Toggle sorting by ego
            BlocBuilder<RatingCubit, RatingState>(
              buildWhen: (p, c) => p.isSortedByEgo != c.isSortedByEgo,
              builder: (context, state) => IconButton(
                onPressed: _cubit.toggleSortingByEgo,
                icon: state.isSortedByEgo
                    ? const Icon(Icons.keyboard_arrow_right_rounded)
                    : const Icon(Icons.keyboard_arrow_left_rounded),
              ),
            ),
          ],

          // Title
          title: const Text('Rating'),

          // Context selector
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
              child: ContextDropDown(onChanged: _cubit.fetch),
            ),
          ),
        ),

        // Rating List
        body: BlocConsumer<RatingCubit, RatingState>(
          listenWhen: (p, c) => c.hasError,
          listener: showSnackBarError,
          buildWhen: (p, c) => c.hasNoError,
          builder: (context, state) => ListView.separated(
            itemCount: state.items.length,
            padding: kPaddingH,
            separatorBuilder: (context, i) => const Divider(),
            itemBuilder: (context, i) => RatingListTile(
              key: ValueKey(state.items[i]),
              userRating: state.items[i],
            ),
          ),
        ),
      );
}
