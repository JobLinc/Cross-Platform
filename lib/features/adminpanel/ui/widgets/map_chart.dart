import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

class MapChart extends StatelessWidget {
  const MapChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewTransformationController = TransformationController();
    // final zoomFactor = 0.8;
    final xTranslate = 900.0;
    final yTranslate = 10.0;
    // viewTransformationController.value.setEntry(0, 0, zoomFactor);
    // viewTransformationController.value.setEntry(1, 1, zoomFactor);
    // viewTransformationController.value.setEntry(2, 2, zoomFactor);
    viewTransformationController.value.setEntry(0, 3, -xTranslate);
    viewTransformationController.value.setEntry(1, 3, -yTranslate);

    return InteractiveViewer(
      constrained: false,
      transformationController: viewTransformationController,
      child: SimpleMap(
        countryBorder: CountryBorder(color: Colors.black),
        instructions: SMapWorld.instructions,
        defaultColor: Colors.grey,
        // colors: SMapWorldColors(eG: Colors.purple).toMap(),
      ),
    );
  }
}
