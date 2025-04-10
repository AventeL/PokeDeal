import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedeal/core/widgets/empty_space.dart';
import 'package:pokedeal/features/collection/presentation/pages/series_list_page.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:pokedeal/features/profile/presentation/pages/profile_page.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_base_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> screens = [TradeBasePage(), SeriesListPage(), ProfilePage()];
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(children: [Expanded(child: _buildScreen(index))]),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: index,
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }

  Widget _buildScreen(int index) {
    return screens[index];
  }

  PreferredSizeWidget? buildAppBar() {
    if (index == 2) {
      return AppBar(
        title: Text("Mon profil"),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/settings");
            },
            icon: Icon(Icons.settings),
          ),
          8.width,
        ],
      );
    }

    return null;
  }
}
