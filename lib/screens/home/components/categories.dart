import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stylish/models/Category.dart';

import '../../../Database/DatabaseHelper.dart';
import '../../../constants.dart';
import '../../../models/categories.dart';

class Categoryi extends StatelessWidget {

  late Future<List<Categories>> demo_categories = DatabaseHelper.instance.getCatsFromLocal();
  // late Future<List<Categories>> demo_categories;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: FutureBuilder<List<Categories>>(
          future: demo_categories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Categories>? data = snapshot.data;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return CategoryCard(
                  icon: data![index].id,
                  title: data![index].category_name,
                  press: () {},
                );
              },
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
}
  }

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String icon, title;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right:8.0),
      child: OutlinedButton(
        onPressed: press,
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: defaultPadding / 2, horizontal: defaultPadding / 4),
          child: Column(
            children: [
              if(icon =='1')
                Image.asset('assets/icons/extra.png',width:39, height:38),
              if(icon =='2')
                Image.asset('assets/icons/bold.png',width:39, height:38),
              if(icon =='3')
                Image.asset('assets/icons/trends.png',width:39, height:38),
              if(icon =='4')
                Image.asset('assets/icons/exclusive.png',width:39, height:38),
              const SizedBox(height: defaultPadding / 2),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
