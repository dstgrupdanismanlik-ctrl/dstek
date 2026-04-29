import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _parentNameController = TextEditingController();
  final _parentPhoneController = TextEditingController();

  String _educationLevel = '12. Sınıf';
  String _targetExam = 'YKS';
  String _fieldOfStudy = 'SAY (MF)';

  bool _isLoading = false;
  bool _isFetching = true; // Sayfa ilk açıldığında verileri çekerken dönecek animasyon

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Ekran açılır açılmaz Firestore'dan verileri getir
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _parentNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  // Firestore'dan öğrencinin mevcut bilgilerini çeken fonksiyon
  Future<void> _loadProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('student_profiles').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _phoneController.text = data['phoneNumber'] ?? '';
          _parentNameController.text = data['parentName'] ?? '';
          _parentPhoneController.text = data['parentPhoneNumber'] ?? '';
          
          if (data['educationLevel'] != null && data['educationLevel'].toString().isNotEmpty) {
            _educationLevel = data['educationLevel'];
          }
          if (data['targetExam'] != null && data['targetExam'].toString().isNotEmpty) {
            _targetExam = data['targetExam'];
          }
          if (data['fieldOfStudy'] != null && data['fieldOfStudy'].toString().isNotEmpty) {
            _fieldOfStudy = data['fieldOfStudy'];
          }
        });
      }
    }
    setState(() => _isFetching = false);
  }

  // Değişiklikleri Firestore'a kaydeden (Update) fonksiyon
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('student_profiles').doc(user.uid).update({
            'phoneNumber': _phoneController.text.trim(),
            'parentName': _parentNameController.text.trim(),
            'parentPhoneNumber': _parentPhoneController.text.trim(),
            'educationLevel': _educationLevel,
            'targetExam': _targetExam,
            'fieldOfStudy': _fieldOfStudy,
          });
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil başarıyla güncellendi!'), backgroundColor: Colors.green),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kayıt Başarısız: $e'), backgroundColor: Colors.redAccent),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFetching) {
      return const Center(child: CircularProgressIndicator());
    }

    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    // Klavye açıldığında bozulmayan kaydırılabilir yapı
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: bottomPadding + 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text('Öğrenci Profilim', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // Telefon
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Telefon Numaranız', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            // Veli Adı
            TextFormField(
              controller: _parentNameController,
              decoration: const InputDecoration(labelText: 'Veli Adı Soyadı', prefixIcon: Icon(Icons.family_restroom), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            // Veli Telefonu
            TextFormField(
              controller: _parentPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Veli Telefon Numarası', prefixIcon: Icon(Icons.phone_android), border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            const Divider(),
            const SizedBox(height: 16),
            const Text('Akademik Bilgiler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
            const SizedBox(height: 16),

            // Öğrenim Durumu (Dropdown)
            DropdownButtonFormField<String>(
              value: _educationLevel,
              decoration: const InputDecoration(labelText: 'Öğrenim Durumu', prefixIcon: Icon(Icons.school), border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: '9. Sınıf', child: Text('9. Sınıf')),
                DropdownMenuItem(value: '10. Sınıf', child: Text('10. Sınıf')),
                DropdownMenuItem(value: '11. Sınıf', child: Text('11. Sınıf')),
                DropdownMenuItem(value: '12. Sınıf', child: Text('12. Sınıf')),
                DropdownMenuItem(value: 'Mezun', child: Text('Mezun')),
              ],
              onChanged: (value) => setState(() => _educationLevel = value!),
            ),
            const SizedBox(height: 16),

            // Hedef Sınav (Dropdown)
            DropdownButtonFormField<String>(
              value: _targetExam,
              decoration: const InputDecoration(labelText: 'Hazırlanılacak Sınav', prefixIcon: Icon(Icons.menu_book), border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'YKS', child: Text('YKS')),
                DropdownMenuItem(value: 'LGS', child: Text('LGS')),
              ],
              onChanged: (value) => setState(() => _targetExam = value!),
            ),
            const SizedBox(height: 16),

            // Alan (Dropdown)
            DropdownButtonFormField<String>(
              value: _fieldOfStudy,
              decoration: const InputDecoration(labelText: 'Alanınız', prefixIcon: Icon(Icons.science), border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: 'SAY (MF)', child: Text('SAY (MF)')),
                DropdownMenuItem(value: 'EA (TM)', child: Text('EA (TM)')),
                DropdownMenuItem(value: 'SÖZ (TS)', child: Text('SÖZ (TS)')),
                DropdownMenuItem(value: 'DİL', child: Text('DİL')),
                DropdownMenuItem(value: 'Alan Yok', child: Text('Alan Yok')),
              ],
              onChanged: (value) => setState(() => _fieldOfStudy = value!),
            ),
            const SizedBox(height: 32),

            // Kaydet Butonu
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Değişiklikleri Kaydet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}