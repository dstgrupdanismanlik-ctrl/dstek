import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/expandable_card.dart';
import '../../profile/screens/profile_screen.dart'; // YENİ EKLENDİ

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Alt sekmelerde gösterilecek geçici ve GERÇEK sayfa içerikleri
  final List<Widget> _pages = [
    // 0. Sekme: Ana Sayfa
    ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text('Hoş Geldin!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        ExpandableCard(title: 'Günün Motivasyonu', icon: Icons.star, content: 'Başarı, küçük çabaların her gün tekrarlanmasıdır.'),
        SizedBox(height: 16),
        ExpandableCard(title: 'Koçluk Notları', icon: Icons.note_alt, content: 'Matematik branşında oran orantı konusuna ağırlık verilmeli.'),
      ],
    ),
    // 1. Sekme: Görevler (Şimdilik geçici)
    const Center(child: Text('Ödevler ve Görevler', style: TextStyle(fontSize: 20))),
    
    // 2. Sekme: PROFIL SAYFASI (GERÇEK SAYFAYA BAĞLANDI)
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DSTEK'),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text('DSTEK Menü', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ayarlar'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                await context.read<AuthProvider>().signOut();
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Görevler'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}