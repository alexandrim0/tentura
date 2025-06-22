import 'dart:math' show Random;
import 'dart:ui' show Offset, Size;
import 'package:force_directed_graphview/force_directed_graphview.dart'
    show FruchtermanReingoldAlgorithm, NodeBase;

import '../../domain/entity/node_details.dart';

Offset initialPositionExtractor(NodeBase node, Size canvasSize) =>
    node is NodeDetails && node.positionHint != 0
    ? canvasSize.center(Offset.zero) +
          Offset(
            // This is needed to prevent degenerate vertical layouts
            ((_random.nextDouble() * 2) - 1) * (_optimalDistance * 0.01),
            // Subtract to move upwards from the center
            -(_verticalShift + _optimalDistance * node.positionHint).toDouble(),
          )
    // Fall back to default behavior for unpinned nodes or nodes without posHint
    : FruchtermanReingoldAlgorithm.defaultInitialPositionExtractor(
        node,
        canvasSize,
      );

const _optimalDistance = 100;

// fit better to vertical screen
const _verticalShift = -200;

final _random = Random();
