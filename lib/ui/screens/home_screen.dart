import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import 'profile_screen.dart';
import 'home_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeContent(),
    const Center(child: Text("Metas", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const Center(child: Text("Estadísticas", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: AppColors.textSecondary,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 28),
              label: "Inicio",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined, size: 28),
              label: "Metas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded, size: 28),
              label: "Estadísticas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded, size: 28),
              label: "Perfil",
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
