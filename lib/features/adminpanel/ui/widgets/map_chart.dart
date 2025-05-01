import 'package:countries_world_map/countries_world_map.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:joblinc/core/widgets/custom_snackbar.dart';

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

    return Stack(
      children: [
        InteractiveViewer(
          constrained: false,
          transformationController: viewTransformationController,
          child: SimpleMap(
            countryBorder: CountryBorder(color: Colors.white),
            instructions: SMapWorld.instructions,
            defaultColor: Colors.grey,
            callback: (id, name, tapDetails) {
              CustomSnackBar.show(
                context: context,
                message: id,
                type: SnackBarType.info,
              );
            },
            // colors: SMapWorldColors(eG: Colors.purple).toMap(),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 5,
            children: [
              Text('Scale'),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.yellow,
                      Colors.purple,
                    ],
                  ),
                ),
                child: SizedBox(
                  width: 20,
                  height: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
