import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/animations/fade_transition.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Disease {
  final String id;
  final String name;

  Disease({
    required this.id,
    required this.name,
  });
}

class UserStats with ChangeNotifier {
  // String name = '';
  String id = '';
  String email = '';
  bool isGarminConnectedIn24=false;

  UserStats(this.id,this.email, this.isGarminConnectedIn24);
// String gender = '';
  // String birth = '';
  // String imageUrl = '';
  // int weight = 0;
  // List<String> reasonForSmoking = [];
  // String amountOfSmoking = '';
  // String sleepTime = '';
  // String awakeTime = '';
  // bool hads = false;
  // bool addiction = false;
  // bool medicalHistory = false;
  // bool isSignedIn = FirebaseAuth.instance.currentUser != null ? true : false;

  // Future<void> uploadUserStats(
  //     {required String nameVal, required String emailVal}) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   name = nameVal;
  //   email = emailVal;
  //
  //   await FirebaseFirestore.instance.collection('Users').doc(userId).set({
  //     'name': name,
  //     'email': email,
  //     'imageUrl': '',
  //     'gender': '',
  //     'birth': '',
  //     'weight': 0,
  //     'reasonForSmoking': [],
  //     'amountOfSmoking': '',
  //     'sleepTime': '',
  //     'awakeTime': '',
  //     'hads': false,
  //     'medicalHistory': false,
  //     'addiction': false,
  //     'isFirstLogin': true,
  //   });
  // }

  // Future<void> uploadPersonalStats(
  //     String genderVal, List<String> diseaesVal) async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   gender = genderVal;
  //   reasonForSmoking = diseaesVal;
  //
  //   // getDate
  //   // getWeight
  //
  //   await FirebaseFirestore.instance.collection('Users').doc(userId).update({
  //     'gender': gender,
  //     'birth': birth,
  //     'weight': weight,
  //     'reasonForSmoking': reasonForSmoking,
  //   });
  // }
  //
  // Future<void> uploadMorePersonalStats() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   await FirebaseFirestore.instance.collection('Users').doc(userId).update({
  //     'amountOfSmoking': amountOfSmoking,
  //     'sleepTime': sleepTime,
  //     'awakeTime': awakeTime,
  //   });
  // }
  //
  // Future<void> fetchUserInfo(BuildContext context) async {
  //   final String? userId = FirebaseAuth.instance.currentUser != null
  //       ? FirebaseAuth.instance.currentUser!.uid
  //       : null;
  //
  //   if (userId == null) {
  //     Navigator.of(context).popUntil((route) => route.isFirst);
  //   }
  //
  //   if (name == '' || email == '') {
  //     try {
  //       final data = await FirebaseFirestore.instance
  //           .collection('Users')
  //           .doc(userId)
  //           .get();
  //
  //       if (data.exists) {
  //         name = data['name'];
  //         email = data['email'];
  //         gender = data['gender'];
  //         imageUrl = data['imageUrl'];
  //         birth = data['birth'];
  //         reasonForSmoking = List<String>.from(data['reasonForSmoking']);
  //         weight = data['weight'];
  //         hads = data['hads'];
  //         addiction = data['addiction'];
  //         medicalHistory = data['medicalHistory'];
  //       }
  //     } catch (error) {
  //       // ignore: avoid_print
  //       print('User Info Fetching error: $error');
  //     }
  //   }
  // }

  // void clearData(BuildContext context) {
  //   name = '';
  //   email = '';
  //   gender = '';
  //   imageUrl = '';
  //   birth = '';
  //   awakeTime = '';
  //   sleepTime = '';
  //   amountOfSmoking = '';
  //   reasonForSmoking = [];
  //   medicalHistory = false;
  //   hads = false;
  //   addiction = false;
  //   weight = 0;
  //   isSignedIn = false;
  //
  //   final questionnaireModel =
  //   Provider.of<Questionnaires>(context, listen: false);
  //   questionnaireModel.clearData();
  // }

  // Future<void> logOut(BuildContext context) async {
  //   clearData(context);
  //
  //   await FirebaseAuth.instance.signOut();
  //   Navigator.of(context).pushAndRemoveUntil(
  //       FadeTransiton(const OnBoardingScreen(), 400), (route) => false);
  // }

  // Future<void> addImage(String imageUrlVal) async {
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   await FirebaseFirestore.instance.collection('Users').doc(userId).update({
  //     'imageUrl': imageUrlVal,
  //   });
  //
  //   imageUrl = imageUrlVal;
  // }
  //
  // Future<void> setQuestionnaireData(Map<String, dynamic> answers,
  //     Questionnaire questionnaire, bool isGrams, BuildContext context) async {
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   final data = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc(userId)
  //       .collection('Questionnaires')
  //       .add({
  //     'date': DateTime.now(),
  //     'questionnaireName': questionnaire.title,
  //     'questionnaireId': questionnaire.id,
  //     'answers': answers,
  //     'isGrams': isGrams,
  //   });
  //
  //   Provider.of<Questionnaires>(context, listen: false).updateRecord(
  //     Record(
  //       answers: answers,
  //       date: DateTime.now().toString(),
  //       isGrams: isGrams,
  //       id: data.id,
  //      // score: questionnaire.score!,
  //       questionnaireId: questionnaire.id!,
  //       questionnaireName: questionnaire.title,
  //     ),
  //   );
  // }
  //
  // Future<void> updateQuestionnaireStatus(String name) async {
  //   final String userId = FirebaseAuth.instance.currentUser!.uid;
  //
  //   final path = FirebaseFirestore.instance.collection('Users').doc(userId);
  //
  //   if (name == 'Medical history questionnaire') {
  //     medicalHistory = true;
  //     await path.update({'medicalHistory': true});
  //   } else if (name == 'Addiction questionnaire') {
  //     addiction = true;
  //     await path.update({'addiction': true});
  //   } else if (name == 'HADS (Hospitalization Anxiety and Depression)') {
  //     hads = true;
  //     await path.update({'hads': true});
  //   }
  // }
  //
  // final List<Disease> _diseases = [];
  //
  // List<Disease> get diseases {
  //   return [..._diseases];
  // }

  // Future<void> fetchDiseases() async {
  //   Locale myLocale = window.locale;
  //
  //   if (_diseases.isEmpty) {
  //     Uri url = Uri.parse(
  //         'https://api.airtable.com/v0/appoPG6GCqcA06gS3/Medical%20condition');
  //     Map<String, String> header = {
  //       'Authorization': 'Bearer keytTWMXzM0cq89Wh'
  //     };
  //     http.Response res = await http.get(url, headers: header);
  //     var jsonData = jsonDecode(res.body);
  //
  //     final List result = jsonData['records'];
  //
  //     for (Map<String, dynamic> disease in result) {
  //       final Disease newDisease = Disease(
  //         id: disease['id'],
  //         name: disease['fields'][myLocale.languageCode == 'he'
  //             ? 'Disease name - HE'
  //             : 'Name'] ??
  //             '',
  //       );
  //
  //       _diseases.add(newDisease);
  //     }
  //
  //     _diseases.sort((a, b) => a.name.toString().compareTo(b.name.toString()));
  //   }
  // }

// Future<void> addDummyData() async {
//   final allUsers = await FirebaseFirestore.instance.collection('Users').get();

//   await Future.forEach(allUsers.docs, (QueryDocumentSnapshot user) async {
//     final records = await FirebaseFirestore.instance
//         .collection('Users')
//         .doc(user.id)
//         .collection('Questionnaires')
//         .get();

//     await Future.forEach(records.docs, (QueryDocumentSnapshot record) async {
//       if (record['questionnaireName'] ==
//           'HADS (Hospitalization Anxiety and Depression)') {
//         await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(user.id)
//             .collection('Questionnaires')
//             .doc(record.id)
//             .update({
//           'score': 5,
//         });
//       } else {
//         await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(user.id)
//             .collection('Questionnaires')
//             .doc(record.id)
//             .update({
//           'score': 0,
//         });
//       }
//     });
//   });
// }


}