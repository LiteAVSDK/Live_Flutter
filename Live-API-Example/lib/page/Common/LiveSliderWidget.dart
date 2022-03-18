
import 'package:flutter/material.dart';

class LiveSliderWidget extends StatefulWidget {

  final ValueChanged<double>? onValueChanged;
  final String title;
  final double minValue;
  final double maxValue;
  double currentValue;
  int? divisions;
  LiveSliderWidget({
    Key? key,
    required this.title,
    required this.minValue,
    required this.maxValue,
    this.currentValue = 0,
    this.divisions,
    this.onValueChanged,
  }) : super(key: key);

  @override
  State<LiveSliderWidget> createState() => _LiveSliderWidgetState();
}

class _LiveSliderWidgetState extends State<LiveSliderWidget> {

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 60.0,
            child: Center (
              child: Text(widget.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
            )
          ),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 60.0,
            child: Slider(
              min: widget.minValue,
              max: widget.maxValue,
              divisions: widget.divisions,
              value: widget.currentValue.toDouble(),
              onChanged: (double value) {
                setState(() {
                  widget.currentValue = value;
                });
                if (widget.onValueChanged != null) {
                  widget.onValueChanged!(value);
                }
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SizedBox(
              height: 60.0,
              child: Center (
                child: Text(widget.currentValue.toStringAsFixed(1), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              )
          ),
        ),
      ],
    );
  }
}