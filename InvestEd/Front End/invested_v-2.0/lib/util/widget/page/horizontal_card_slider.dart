import 'package:flutter/material.dart';

class HorizontalCardSlider extends StatefulWidget {
  List<Widget> cards;
  HorizontalCardSlider({super.key, this.cards = const []});

  @override
  State<HorizontalCardSlider> createState() => _HorizontalCardSliderState();
}

class _HorizontalCardSliderState extends State<HorizontalCardSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 275,
        width: MediaQuery.of(context).size.width * 0.9,
        child: PageView.builder(
            itemCount: widget.cards.length,
            pageSnapping: true,
            itemBuilder: (context, pagePosition) {
              return widget.cards[pagePosition];
            }));
  }
}