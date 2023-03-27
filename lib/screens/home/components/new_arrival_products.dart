import 'package:flutter/material.dart';
import 'package:stylish/Database/Product.dart';
import 'package:stylish/models/Product.dart';
import 'package:stylish/screens/details/details_screen.dart';

import '../../../Database/DatabaseHelper.dart';
import '../../../constants.dart';
import 'product_card.dart';
import 'section_title.dart';

class NewArrivalProducts extends StatelessWidget {
  late Future<List<Product1>> demo_products =
      DatabaseHelper.instance.getCProducts('1');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: defaultPadding),
          child: SectionTitle(
            title: "New Arrival",
            pressSeeAll: () {},
          ),
        ),
        FutureBuilder<List<Product1>>(
            future: demo_products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product1>? data = snapshot.data;
                return ListView.builder(
                  itemCount: data?.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: defaultPadding),
                      child: ProductCard(
                        title: demo_product[index].title,
                        image: demo_product[index].image,
                        price: demo_product[index].price.toDouble(),
                        bgColor: demo_product[index].bgColor,
                        press: () {

                        },
                      ),
                    );
                  },

                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
    );
  }
}
