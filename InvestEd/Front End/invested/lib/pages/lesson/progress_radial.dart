import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/custom_text.dart';

class ProgressRadial extends StatelessWidget {
  const ProgressRadial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 65,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.grey,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              color: Color(global_styling.LOGO_COLOR),
              value: 50,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
          annotations: [
            GaugeAnnotation(
              positionFactor: 0.1,
                widget: CustomText(
                  text: "50%"
                )
            )
          ],
        )
      ],
      ),
    );
  }
}
