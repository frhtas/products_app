import 'package:flutter/material.dart';
import 'package:products_app/util/services.dart';
import 'package:products_app/widgets/my_progress_indicator.dart';
import 'package:products_app/widgets/product_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() {
    try {
      Services.getCategories().then((value) {
        setState(() {
          categories = value;
          tabController = TabController(length: categories.length, vsync: this);
          print(categories);
        });
      });
    } catch (e) {
      print(e);
    }
  }

  String formatString(String str) {
    List<String> words = str.split("-");
    words = words
        .map((e) =>
            e.substring(0, 1).toUpperCase() + e.substring(1).toLowerCase())
        .toList();
    return words.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return categories.isNotEmpty
        ? Scaffold(
            appBar: AppBar(
              title: TabBar(
                controller: tabController,
                isScrollable: true,
                tabs:
                    categories.map((e) => Tab(text: formatString(e))).toList(),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: categories
                  .map((e) => Center(child: ProductList(category: e)))
                  .toList(),
            ),
          )
        : const MyProgressIndicator();
  }
}
