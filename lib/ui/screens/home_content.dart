import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/colors.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String userName = "Usuario";
        if (snapshot.hasData && snapshot.data!.exists) {
          userName = (snapshot.data!.data() as Map<String, dynamic>)['name'] ?? "Usuario";
          // Tomar solo el primer nombre
          userName = userName.split(' ')[0];
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(userName),
              const SizedBox(height: 24),
              _buildMainBalanceCard(),
              const SizedBox(height: 20),
              _buildFinanceCategories(),
              const SizedBox(height: 24),
              _buildMainGoalCard(),
              const SizedBox(height: 24),
              _buildRecentActivityHeader(),
              const SizedBox(height: 16),
              _buildRecentActivityList(),
              const SizedBox(height: 100), // Espacio para la barra inferior
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, $name! 👋",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "Aquí tienes tu resumen financiero.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ],
        ),
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 30),
              onPressed: () {},
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
              ),
            )
          ],
        )
      ],
    );
  }

  Widget _buildMainBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text("Saldo total", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(width: 8),
              const Icon(Icons.visibility_outlined, color: AppColors.textSecondary, size: 18),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "S/ 8,450.00",
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            "▲ 5.2% este mes",
            style: TextStyle(color: Colors.greenAccent, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCategories() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _buildCategoryItem(Icons.account_balance_wallet_outlined, "Ahorros", "S/ 5,000", Colors.green),
          const Divider(color: AppColors.secondary, height: 1, indent: 60),
          _buildCategoryItem(Icons.credit_card, "Gastos", "S/ 2,300", Colors.orange),
          const Divider(color: AppColors.secondary, height: 1, indent: 60),
          _buildCategoryItem(Icons.bar_chart_rounded, "Inversiones", "S/ 1,150.00", Colors.blue),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, String amount, Color color) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(amount, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
        ],
      ),
    );
  }

  Widget _buildMainGoalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Meta principal", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Viaje", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("S/ 10,000.00", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(10)),
              ),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(color: Colors.greenAccent, borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Faltan: S/ 2,000.00", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const Text("80%", style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Actividad reciente", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text("Ver todo", style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
      ],
    );
  }

  Widget _buildRecentActivityList() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          _buildActivityItem(Icons.verified_user_rounded, "Aporte a meta Viaje", "Hoy", "+S/ 100.00", Colors.greenAccent),
          const Divider(color: AppColors.secondary, height: 1, indent: 60),
          _buildActivityItem(Icons.shopping_cart_rounded, "Supermercado", "Ayer", "-S/ 45.00", Colors.redAccent),
          const Divider(color: AppColors.secondary, height: 1, indent: 60),
          _buildActivityItem(Icons.star_rounded, "Ahorro automático", "Ayer", "+S/ 20.00", Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String date, String amount, Color amountColor) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(14)),
        child: Icon(icon, color: Colors.white70, size: 24),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15)),
      subtitle: Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      trailing: Text(
        amount,
        style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
