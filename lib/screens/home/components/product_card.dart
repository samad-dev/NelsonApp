import 'package:flutter/material.dart';

import '../../../constants.dart';

class ProductCard extends StatelessWidget {
   ProductCard({
    Key? key,
    required this.image,
    required this.title,
    required this.price,
    required this.press,
    required this.bgColor,
  }) : super(key: key);
  final String image, title;
  final VoidCallback press;
  final double price;
  final Color bgColor;
  var images;

  @override
  Widget build(BuildContext context) {
    if(image =='1')
      {
        images='assets/icons/extra.png';
      }
    if(image =='2')
    {
      images='assets/icons/bold.png';
    }
    if(image =='3')
    {
      images='assets/icons/trends.png';
    }
    if(image =='4')
    {
      images='assets/icons/exclusive.png';
    }
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(defaultPadding / 2),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.all(
                    Radius.circular(defaultBorderRadius)),
              ),
              child: Image.asset(
                images,
                height: 100,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
