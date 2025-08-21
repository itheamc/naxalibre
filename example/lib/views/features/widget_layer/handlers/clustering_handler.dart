import 'dart:math';
import 'dart:ui';

import '../models/geojson.dart';

class ClusteringHandler {
  ClusteringHandler._();

  /// Method to cluster the visible features if necessary.
  /// [features] List of visible features
  /// [radius] Radius in pixel to cluster (used in screen space here)
  ///
  static List<Feature> cluster(List<Feature> features, {double radius = 15}) {
    // Final list to store clustered features
    final list = <Feature>[];

    // A list to keep track of which features have been clustered
    final clustered = <Feature>{};

    for (final feature in features) {
      if (clustered.contains(feature)) continue;

      // Initialize a new cluster group with the current feature
      final group = <Feature>[feature];
      clustered.add(feature);

      for (final other in features) {
        if (clustered.contains(other)) continue;

        // If both features have an offset (screen position in pixel)
        if (feature.offset != null && other.offset != null) {
          final dx = feature.offset!.dx - other.offset!.dx;
          final dy = feature.offset!.dy - other.offset!.dy;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance <= radius) {
            group.add(other);
            clustered.add(other);
          }
        }
      }

      if (group.length > 1) {
        // Calculate the center of the cluster
        final center = _calculateCentroid(group);

        // Create a new cluster feature
        list.add(
          Feature(
            id: 'cluster_${clustered.length}',
            isCluster: true,
            offset: center,
            clusteredFeatures: group,
          ),
        );
      } else {
        list.add(feature); // Add as-is
      }
    }

    return list;
  }

  /// Calculate centroid from list of features
  static Offset _calculateCentroid(List<Feature> features) {
    double totalX = 0;
    double totalY = 0;
    int count = 0;

    for (final feature in features) {
      if (feature.offset != null) {
        totalX += feature.offset!.dx;
        totalY += feature.offset!.dy;
        count++;
      }
    }

    return Offset(totalX / count, totalY / count);
  }
}
