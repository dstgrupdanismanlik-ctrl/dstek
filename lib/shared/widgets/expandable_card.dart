import 'package:flutter/material.dart';

class ExpandableCard extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Widget content; // Kart açıldığında görünecek her türlü widget

  const ExpandableCard({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      // ExpansionTile, Flutter'ın kendi içindeki genişleyebilir liste elemanıdır
      child: ExpansionTile(
        leading: Icon(leadingIcon, color: Colors.blueAccent),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        iconColor: Colors.blueAccent,
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Kart açıldığında içeriği buraya basıyoruz
          content,
        ],
      ),
    );
  }
}