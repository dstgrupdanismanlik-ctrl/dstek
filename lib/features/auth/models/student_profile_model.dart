class StudentProfileModel {
  // İletişim Bilgileri
  final String phoneNumber;
  final String parentName;
  final String parentPhoneNumber;

  // Akademik Profil
  final String educationLevel; // Örn: 12. Sınıf, Mezun
  final String targetExam; // Örn: YKS, LGS
  final String fieldOfStudy; // Örn: SAY (MF), EA (TM)

  // Net & Başarı Takibi (Harita - Map Kullanımı)
  final Map<String, dynamic> initialScores; // Örn: {'TYT': 55.5, 'AYT': 30.0}
  final Map<String, dynamic> targetScores; // Örn: {'TYT': 80.0, 'AYT': 60.0}

  // Koçluk Baremleri ve Sistem Dinamikleri
  final int topicCompletionThreshold; // konu_tamam_baremi (örn: 85)
  final int questionSolveThreshold; // soru_coz_baremi
  final int studySolveThreshold; // calis_coz_baremi
  final int getSupportThreshold; // destek_al_baremi (Yeni Eklendi)
  final DateTime? coachingStartDate; // kocluk_baslangic_tarihi

  StudentProfileModel({
    required this.phoneNumber,
    required this.parentName,
    required this.parentPhoneNumber,
    required this.educationLevel,
    required this.targetExam,
    required this.fieldOfStudy,
    required this.initialScores,
    required this.targetScores,
    required this.topicCompletionThreshold,
    required this.questionSolveThreshold,
    required this.studySolveThreshold,
    required this.getSupportThreshold,
    this.coachingStartDate,
  });

  // Firestore'dan (Veritabanından) gelen veriyi Flutter Objesine çevirir
  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      phoneNumber: json['phoneNumber'] ?? '',
      parentName: json['parentName'] ?? '',
      parentPhoneNumber: json['parentPhoneNumber'] ?? '',
      educationLevel: json['educationLevel'] ?? '',
      targetExam: json['targetExam'] ?? '',
      fieldOfStudy: json['fieldOfStudy'] ?? '',
      initialScores: json['initialScores'] ?? {},
      targetScores: json['targetScores'] ?? {},
      topicCompletionThreshold: json['topicCompletionThreshold'] ?? 85, // Varsayılan %85
      questionSolveThreshold: json['questionSolveThreshold'] ?? 75,
      studySolveThreshold: json['studySolveThreshold'] ?? 65,
      getSupportThreshold: json['getSupportThreshold'] ?? 65,
      coachingStartDate: json['coachingStartDate'] != null
          ? DateTime.parse(json['coachingStartDate'])
          : null,
    );
  }

  // Flutter Objesini Firestore'a (Veritabanına) yazmak için formata çevirir
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'parentName': parentName,
      'parentPhoneNumber': parentPhoneNumber,
      'educationLevel': educationLevel,
      'targetExam': targetExam,
      'fieldOfStudy': fieldOfStudy,
      'initialScores': initialScores,
      'targetScores': targetScores,
      'topicCompletionThreshold': topicCompletionThreshold,
      'questionSolveThreshold': questionSolveThreshold,
      'studySolveThreshold': studySolveThreshold,
      'getSupportThreshold': getSupportThreshold,
      'coachingStartDate': coachingStartDate?.toIso8601String(),
    };
  }
}