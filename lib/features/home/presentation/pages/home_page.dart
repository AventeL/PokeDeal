import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedeal/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:pokedeal/features/home/presentation/widgets/custom_bottom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> screens = [
    Center(child: Text('Echanges')),
    Center(child: Text('Collection')),
    Center(child: Text('Profil')),
  ];
  int index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Expanded(child: _buildScreen(index)),
            FloatingActionButton(
              onPressed: () {
                context.read<AuthenticationBloc>().add(
                  AuthenticationEventSignOut(),
                );
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
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
