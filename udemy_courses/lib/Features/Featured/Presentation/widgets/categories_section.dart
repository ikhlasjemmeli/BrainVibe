import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import 'category_card.dart';

class CategoriesSection extends StatelessWidget {
  final CategoryController controller;
  final VoidCallback playClickSound;

  const CategoriesSection({
    Key? key,
    required this.controller,
    required this.playClickSound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text('explorer_categories'.tr, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: playClickSound,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xff6849ef), Color(0xff764ba2)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:  Text('voir_tout'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: Obx(() {
            final categories = controller.listcategories;
            if (categories.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xff6849ef))),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) =>
                  CategoryCard(category: categories[index], index: index, onTap: playClickSound),
            );
          }),
        ),
      ],
    );
  }
}
