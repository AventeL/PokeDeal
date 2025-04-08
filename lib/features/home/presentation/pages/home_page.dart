import 'package:flutter/material.dart';
import 'package:pokedeal/features/collection/presentation/pages/series_list_page.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';
import 'package:pokedeal/features/trade/presentation/pages/trade_base_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> screens = [
    TradeBasePage(),
    SeriesListPage(),
    Center(child: Text('Profil')),
  ];
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
}
