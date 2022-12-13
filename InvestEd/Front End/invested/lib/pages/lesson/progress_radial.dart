import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:invested/util/global_styling.dart' as global_styling;

import '../../util/custom_text.dart';

class ProgressRadial extends StatelessWidget {
  final double percentageComplete;
  final double percentageFontSize;
  final double size;
  const ProgressRadial({
    Key? key,
    this.percentageComplete = 0,
    this.percentageFontSize = 13,
    this.size = 65,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
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
              value: percentageComplete,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
          annotations: [
            GaugeAnnotation(
              positionFactor: 0.1,
                widget: CustomText(
                  text: "${percentageComplete.toStringAsFixed(2)}%",
                  fontSize: percentageFontSize,
                )
            )
          ],
        )
      ],
      ),
    );
  }
}
