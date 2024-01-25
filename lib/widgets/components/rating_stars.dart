import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  const RatingStars({super.key, this.startFrom = 5, this.onPressed});
  final int startFrom;
  final void Function(int)? onPressed;

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.startFrom - 1;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          icon: Icon(
            index > rating ? Icons.star_outline : Icons.star,
            color: Colors.amber,
          ),
          onPressed: () {
            setState(() {
              rating = index;
            });
            widget.onPressed?.call(rating + 1);
          },
        ),
      ),
    );
  }
}
