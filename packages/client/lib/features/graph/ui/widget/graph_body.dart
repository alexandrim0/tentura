import 'package:nil/nil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:force_directed_graphview/force_directed_graphview.dart';

import '../../domain/entity/edge_details.dart';
import '../../domain/entity/node_details.dart';
import '../utils/animated_highlighted_edge_painter.dart';
import '../utils/ease_in_out_reynolds.dart';
import '../bloc/graph_cubit.dart';
import 'graph_node_widget.dart';
import 'dart:math' as math;

class GraphBody extends StatefulWidget {
  const GraphBody({
    this.isLabeled = true,
    this.labelSize = const Size(100, 20),
    this.scaleRange = const Offset(0.1, 3),
    this.animationDuration = const Duration(seconds: 2),
    this.canvasSize = const GraphCanvasSize.fixed(Size(4096, 4096)),
    this.layoutAlgorithm = const FruchtermanReingoldAlgorithm(
      iterations: kIsWeb && !kIsWasm ? 300 : 500,
      temperature: 500,
      optimalDistance: 100,
      showIterations: true,
      initialPositionExtractor: _initialPositionExtractor,
    ),
    super.key,
  });

  final bool isLabeled;
  final Size labelSize;
  final Offset scaleRange;
  final Duration animationDuration;
  final GraphCanvasSize canvasSize;
  final GraphLayoutAlgorithm layoutAlgorithm;

  static final _random = math.Random();

  @override
  GraphBodyState createState() => GraphBodyState();

  static Offset _initialPositionExtractor(NodeBase node, Size canvasSize) {
    if (node is NodeDetails && node.posHint != null) {
      final centerX = canvasSize.width / 2;
      final centerY = canvasSize.height / 2;
      const optimalDistance = 100;
      const verticalShift = -200; // fit better to vertical screen

      final verticalPosition = verticalShift + optimalDistance * node.posHint!;

      // This is needed to prevent degenerate vertical layouts
      final horizontalDisplacement = ((_random.nextDouble() * 2) - 1) * (optimalDistance * 0.01);

      return Offset(
          centerX + horizontalDisplacement,
          centerY - verticalPosition // Subtract to move upwards from the center
      );

    }
    // Fall back to default behavior for unpinned nodes or nodes without posHint
    return FruchtermanReingoldAlgorithm.defaultInitialPositionExtractor(node, canvasSize);
  }
}

class GraphBodyState extends State<GraphBody>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: widget.animationDuration,
    vsync: this,
  );

  late final _cubit = context.read<GraphCubit>();

  @override
  void initState() {
    super.initState();
    if (_cubit.state.isAnimated) _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      GraphView<NodeDetails, EdgeDetails<NodeDetails>>(
        controller: _cubit.graphController,
        canvasSize: widget.canvasSize,
        minScale: widget.scaleRange.dx,
        maxScale: widget.scaleRange.dy,
        layoutAlgorithm: widget.layoutAlgorithm,
        edgePainter: AnimatedHighlightedEdgePainter(
          animation: CurvedAnimation(
            parent: _animationController,
            curve: const EaseInOutReynolds(),
          ),
          highlightRadius: 0.15,
          highlightColor: Theme.of(context).colorScheme.surface,
          isAnimated: _cubit.state.isAnimated,
        ),
        labelBuilder: widget.isLabeled
            ? BottomLabelBuilder(
                labelSize: widget.labelSize,
                builder: (context, node) => switch (node) {
                  final UserNode node => Text(
                      key: ValueKey(node),
                      node.label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  _ => nil,
                },
              )
            : null,
        nodeBuilder: (context, node) => GraphNodeWidget(
          key: ValueKey(node),
          nodeDetails: node,
          onTap: () => _cubit.setFocus(node),
          onDoubleTap: () => _cubit.showNodeDetails(node),
        ),
      );
}