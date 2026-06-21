import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/colors.dart';
import '../../services/auth_service.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showInfo(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Accediendo a: $feature"),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("No se encontró sesión activa")));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Mi cuenta",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () => _showInfo(context, "Ajustes rápidos"),
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final userData = snapshot.hasData && snapshot.data!.exists 
              ? snapshot.data!.data() as Map<String, dynamic> 
              : <String, dynamic>{};
          
          final String name = userData['name'] ?? "Usuario";
          final String email = userData['email'] ?? currentUser.email ?? "Sin correo";
          final String initials = name.isNotEmpty ? name.substring(0, 2).toUpperCase() : "??";
          
          String memberSince = "Mar 2024"; // Valor base diseño
          if (userData['createdAt'] != null) {
            Timestamp t = userData['createdAt'];
            DateTime date = t.toDate();
            List<String> months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
            memberSince = "${months[date.month - 1]} ${date.year}";
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header de Usuario
                _buildUserHeader(context, name, email, initials),
                const SizedBox(height: 24),
                
                // Cards de Info
                _buildStatusCards(memberSince),
                const SizedBox(height: 32),
                
                const Text(
                  "Cuenta",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                
                // Bloque 1: Cuenta
                _buildSectionContainer([
                  _buildMenuItem(context, Icons.person_outline, "Información personal", "Edita tus datos personales", Colors.green),
                  _buildMenuItem(context, Icons.lock_outline, "Seguridad", "Cambia tu contraseña y más", Colors.blue),
                  _buildMenuItem(context, Icons.notifications_none, "Notificaciones", "Gestiona tus alertas y preferencias", Colors.purple),
                  _buildMenuItem(context, Icons.credit_card, "Métodos de pago", "Administra tus tarjetas y cuentas", Colors.orange),
                  _buildMenuItem(context, Icons.cloud_download_outlined, "Exportar datos", "Descarga tu información financiera", Colors.cyan),
                  _buildMenuItem(context, Icons.help_outline, "Ayuda y soporte", "Centro de ayuda y contacto", Colors.blueAccent),
                ]),

                const SizedBox(height: 32),
                const Text(
                  "Preferencias",
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),

                // Bloque 2: Preferencias
                _buildSectionContainer([
                  _buildPreferenceItem(context, Icons.dark_mode_outlined, "Tema de la app", "Oscuro", Colors.deepPurpleAccent),
                  _buildPreferenceItem(context, Icons.language, "Idioma", "Español", Colors.teal),
                  _buildPreferenceItem(context, Icons.monetization_on_outlined, "Moneda", "Soles (S/)", Colors.green),
                ]),

                const SizedBox(height: 32),

                // Bloque 3: Cerrar Sesión
                _buildSectionContainer([
                  ListTile(
                    onTap: () async {
                      await authService.signOut();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.logout, color: Colors.orange),
                    ),
                    title: const Text("Cerrar sesión", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
                  ),
                ]),

                const SizedBox(height: 40),
                
                // Footer
                const Center(
                  child: Column(
                    children: [
                      Text("Versión 1.2.0", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Hecho con ", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Icon(Icons.favorite, color: Colors.greenAccent, size: 14),
                          Text(" para tu bienestar financiero.", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildUserHeader(BuildContext context, String name, String email, String initials) {
    return InkWell(
      onTap: () => _showInfo(context, "Perfil de usuario"),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.accentGreen.withValues(alpha: 0.2),
                  child: Text(
                    initials,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.accentGreen),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text(email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.accentGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, size: 16, color: AppColors.accentGreen),
                        SizedBox(width: 6),
                        Text("Plan Premium", style: TextStyle(color: AppColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCards(String memberSince) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatusItem(Icons.account_balance_wallet_outlined, "Miembro desde", memberSince),
          _buildDivider(),
          _buildStatusItem(Icons.verified_user_outlined, "Seguridad", "Activa", valueColor: AppColors.accentGreen),
          _buildDivider(),
          _buildStatusItem(Icons.star_outline, "Puntos", "1,250"),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, String value, {Color? valueColor}) {
    return Column(
      children: [
        Icon(icon, color: AppColors.accentGreen, size: 24),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor ?? Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: AppColors.secondary.withValues(alpha: 0.5));
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String subtitle, Color iconColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
      onTap: () => _showInfo(context, title),
    );
  }

  Widget _buildPreferenceItem(BuildContext context, IconData icon, String title, String currentVal, Color iconColor) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(currentVal, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, color: AppColors.textSecondary, size: 14),
        ],
      ),
      onTap: () => _showInfo(context, title),
    );
  }
}
