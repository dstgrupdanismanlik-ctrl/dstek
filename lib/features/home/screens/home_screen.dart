import 'package:flutter/material.dart';
// Ortak bileşenimiz olan ExpandableCard'ı içe aktarıyoruz
import '../../../shared/widgets/expandable_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Alt sekmelerde gösterilecek sayfa içerikleri
  final List<Widget> _pages = [
    // 1. Sekme: Ana Sayfa (Genişleyebilir Kartlarımızı buraya ekledik)
    ListView(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      children: const [
        ExpandableCard(
          title: 'Haftalık Koçluk Notu',
          leadingIcon: Icons.menu_book,
          content: Text(
            'Bu hafta matematikte türev konusuna ağırlık vermelisin. Deneme sınavındaki hataların genellikle işlem hatasından kaynaklanıyor. Lütfen daha dikkatli ol.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
        ExpandableCard(
          title: 'Sistem Duyurusu',
          leadingIcon: Icons.campaign,
          content: Text(
            'Yarın saat 10:00 ile 12:00 arasında sistemde bakım çalışması yapılacaktır. Lütfen bu saatler arasında deneme girişi yapmayınız.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ),
      ],
    ),
    // 2. Sekme: Ödevler
    const Center(child: Text('Ödevler ve Görevler', style: TextStyle(fontSize: 20))),
    // 3. Sekme: Profil
    const Center(child: Text('Profil', style: TextStyle(fontSize: 20))),
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
      // Sol taraftan açılan Hamburger Menü
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
              onTap: () {
                // İleride ayarlar rotasına yönlendirme yapılacak
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Çıkış Yap'),
              onTap: () {
                // İleride oturum kapatma işlemleri buraya eklenecek
              },
            ),
          ],
        ),
      ),
      // Seçilen sekmeye göre değişen orta içerik alanı
      body: _pages[_selectedIndex],
      // Ekranın altındaki hızlı gezinme çubuğu
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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