import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:tentura_root/i10n/I10n.dart';

import 'package:tentura/ui/utils/ui_utils.dart';

import 'package:tentura/features/profile/ui/bloc/profile_cubit.dart';
// import 'package:tentura/features/context/ui/widget/context_drop_down.dart';

import '../../data/repository/graph_repository.dart';
import '../bloc/graph_cubit.dart';
import '../widget/graph_body.dart';

@RoutePage()
class GraphScreen extends StatelessWidget implements AutoRouteWrapper {
  const GraphScreen({
    @queryParam this.focus = '',
    super.key,
  });

  final String focus;

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => GraphCubit(
          GetIt.I<GraphRepository>(),
          me: GetIt.I<ProfileCubit>().state.profile,
          focus: focus,
        ),
        child: BlocListener<GraphCubit, GraphState>(
          listener: commonScreenBlocListener,
          child: this,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GraphCubit>();
    return Scaffold(
      appBar: AppBar(
        // Menu :
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry<void>>[
                PopupMenuItem<void>(
                  onTap: cubit.jumpToEgo,
                  child: Text(I10n.of(context)!.goToEgo),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<void>(
                  onTap: cubit.togglePositiveOnly,
                  child: cubit.state.positiveOnly
                      ? Text(I10n.of(context)!.showNegative)
                      : Text(I10n.of(context)!.hideNegative),
                ),
              ];
            },
          ),
        ],

        // Title
        title: Text(I10n.of(context)!.graphView),

        // Context selector
        // (hidden for now)
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(40),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
        //     child: ContextDropDown(onChanged: cubit.setContext),
        //   ),
        // ),
      ),

      // Graph
      body: const GraphBody(),
    );
  }
}
