import 'package:flutter/material.dart';
import 'package:naxalibre_example/views/features/annotations_management/annotations_management_screen.dart';
import 'package:naxalibre_example/views/features/offline_management/offline_management_screen.dart';

import '../../common/feature_card.dart';
import '../basic_map_controls/basic_map_controls_screen.dart';
import '../camera_animations/camera_animations_screen.dart';
import '../layers_management/layer_management_screen.dart';
import '../location_features/location_features_screen.dart';
import '../map_performance/map_performance_screen.dart';
import '../map_utilities/map_utilities_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NaxaLibre Features')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FeatureCard(
            title: 'Basic Map Controls',
            description: 'Zoom in/out, toggle style, and camera animations',
            icon: Icons.map_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BasicMapControlsScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Camera Animations',
            description: 'Various camera animation techniques',
            icon: Icons.animation,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CameraAnimationsScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Layer Management',
            description: 'Add and manage different map layers',
            icon: Icons.layers_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LayerManagementScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Annotation Management',
            description: 'Add and manage different map annotations',
            icon: Icons.control_point_duplicate,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnnotationsManagementScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Location Features',
            description: 'Location tracking and services',
            icon: Icons.share_location_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LocationFeaturesScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Map Performance',
            description: 'FPS settings and optimization',
            icon: Icons.speed,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MapPerformanceScreen(),
                  ),
                ),
          ),
          FeatureCard(
            title: 'Map Utilities',
            description: 'Snapshot, JSON export, and other utilities',
            icon: Icons.build_circle_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MapUtilitiesScreen()),
                ),
          ),
          FeatureCard(
            title: 'Offline Management',
            description: 'Offline region downloading and management',
            icon: Icons.download_for_offline_outlined,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OfflineManagementScreen(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
