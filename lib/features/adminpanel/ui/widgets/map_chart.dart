import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';

class MapChart extends StatelessWidget {
  const MapChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: SimpleMap(
        instructions: SMapWorld.instructions,
        defaultColor: Colors.grey,
        colors: SMapWorldColors().toMap(),
      ),
    );
  }
}
