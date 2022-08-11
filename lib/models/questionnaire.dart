import 'dart:convert';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;


class Question {
  final String? id;
  final String question;
  final List<String>? questionnaireIds;
  final List<AnswerAndImage> answersAndImages;
  final List<String>? answers;
  final List<String> answersImages;
  final List<int>? scores;
  final String anwersType;
  final bool isAssetsAnswers;
  String answer = '';
  int delay = 1500;

  Question({
    this.id,
    required this.question,
    required this.answer,
    required this.answers,
    required this.scores,
    required this.delay,
    required this.anwersType,
    required this.isAssetsAnswers,
    required this.questionnaireIds,
    required this.answersAndImages,
    required this.answersImages,
  });
}

class Questionnaire {
  final String? id;
  final String title;
  final String heTitle;
  final String description;
  final List<String>? diseases;
  final String openingMessage;
  final String endMessage;
  final int frequency;
  final int? score;
  List<Question> questions;

  Questionnaire({
    this.id,
    required this.title,
    required this.description,
    required this.diseases,
    required this.frequency,
    required this.questions,
    required this.score,
    required this.openingMessage,
    required this.endMessage,
    required this.heTitle,
  });
}

class Record {
  final String? id;
  final String questionnaireName;
  final String questionnaireId;
  final String date;
  final bool isGrams;
  final Map<String, dynamic> answers;

  Record({
    this.id,
    required this.date,
    required this.questionnaireName,
    required this.questionnaireId,
    required this.answers,
    required this.isGrams,
  });
}

class AnswerAndImage {
  final String answer;
  final String? image;

  AnswerAndImage({
    required this.answer,
    required this.image,
  });
}

class Questionnaires with ChangeNotifier {
  // logic

  final List<Questionnaire> _questionnaires = [];

  List<Questionnaire> get questionnaires {
    return [..._questionnaires];
  }

  final List<Question> _questions = [];

  List<Question> get questions {
    return [..._questions];
  }

  Future<void> fetchQuestionnaires(BuildContext context) async {
    if (_questionnaires.isEmpty) {
      Uri url = Uri.parse(
          'https://api.airtable.com/v0/appoPG6GCqcA06gS3/%D7%A9%D7%90%D7%9C%D7%95%D7%A0%D7%99%D7%9D');
      Map<String, String> header = {
        'Authorization': 'Bearer keytTWMXzM0cq89Wh'
      };
      http.Response res = await http.get(url, headers: header);
      var jsonData = jsonDecode(res.body);
      final List result = jsonData['records'];

      for (Map<String, dynamic> questionnaire in result) {
        Questionnaire newQuestionnaire = Questionnaire(
          id: questionnaire['id'],
          description: questionnaire['fields']['Description'] ?? '',
          diseases: List<String>.from(
              questionnaire['fields']['Medical condition'] ?? []),
          endMessage: '',
          heTitle: questionnaire['fields']['Questionnaire title - HE'],
          openingMessage: questionnaire['fields']['Opening message'] ?? '',
          score: questionnaire['fields']['Score'],
          title: questionnaire['fields']['Questionnaire title'],
          frequency: 1,
          questions: [],
        );

        _questionnaires.add(newQuestionnaire);
      }

      addIntakeQuestionnaire(context);
    }
  }

  Future<void> fetchQuestions(BuildContext context) async {
    Locale myLocale = window.locale;

    if (_questions.isEmpty) {
      Uri url = Uri.parse(
          'https://api.airtable.com/v0/appoPG6GCqcA06gS3/%D7%A9%D7%90%D7%9C%D7%95%D7%AA?&view=Grid%20view');
      Map<String, String> header = {
        'Authorization': 'Bearer keytTWMXzM0cq89Wh'
      };
      http.Response res = await http.get(url, headers: header);
      var jsonData = jsonDecode(res.body);

      final List result = jsonData['records'];

      for (Map<String, dynamic> question in result) {
        List<dynamic>? imagesData = question['fields']['Images'];
        List<String>? imageUrls = [];

        if (imagesData != null) {
          for (var element in imagesData) {
            if (element['url'] != null) {
              imageUrls.add(element['url']);
            }
          }
        }

        List<String>? answers =
        List<String>.from(question['fields']['Answers'] ?? []);

        List<AnswerAndImage> answersAndImages = [];

        int i = 0;

        for (var element in answers) {
          answersAndImages.add(
            AnswerAndImage(
                answer: element,
                image: imageUrls.length > i ? imageUrls[i] : ''),
          );
          i++;
        }

        List<dynamic>? scroses = question['fields']['Score'];

        Question newQuestion = Question(
          id: question['id'],

          // ignore: prefer_null_aware_operators
          scores: scroses != null
              ? scroses.map((data) => int.parse(data)).toList()
              : null,
          answer: '',
          answers: List<String>.from(question['fields']['Answers'] ?? []),
          question: myLocale.languageCode == 'he'
          // ? question['fields']['Name -heb']
             // : question['fields']['Name -en'],
             ? question['fields']['Questions - HE']
            : question['fields']['Questions - EN'],

          questionnaireIds:
          List<String>.from(question['fields']['Questionnaire'] ?? []),
          delay: 800,
          isAssetsAnswers: false,
          anwersType: question['fields']['Answer type'],
          answersImages: imageUrls,
          answersAndImages: answersAndImages,
        );

        _questions.add(newQuestion);

        for (var id in newQuestion.questionnaireIds!) {
          final int index =
          questionnaires.indexWhere((element) => element.id == id);
          if (index != -1) {
            questionnaires[index].questions.add(newQuestion);
          }
        }
      }
    }
  }

  void addIntakeQuestionnaire(BuildContext context) {
    // Locale myLocale = window.locale;

    final Questionnaire intakeQuestionnaire = Questionnaire(
      title: 'Intake Questionnaire',
      id: 'intakeQuestionnaire',
      heTitle: 'שאלון צריכה',
      description: '',
      diseases: [],
      frequency: 0,
      questions: [
        Question(
          question: AppLocalizations.of(context)!.howSevereBefore,
          answer: '',
          answers: [],
          scores: [],
          delay: 800,
          anwersType: 'Emoji',
          isAssetsAnswers: true,
          questionnaireIds: [],
          answersAndImages: [
            AnswerAndImage(answer: '1', image: 'terrible'),
            AnswerAndImage(answer: '2', image: 'very-bad'),
            AnswerAndImage(answer: '3', image: 'not-good'),
            AnswerAndImage(answer: '4', image: 'average'),
            AnswerAndImage(answer: '5', image: 'good'),
          ],
          answersImages: [],
        ),
        Question(
          question: AppLocalizations.of(context)!.whatProduct,
          answer: '',
          answers: [],
          scores: [],
          delay: 800,
          anwersType: 'PickProduct',
          isAssetsAnswers: false,
          questionnaireIds: [],
          answersAndImages: [],
          answersImages: [],
        ),
        Question(
          question: AppLocalizations.of(context)!.howMuchConsuming,
          answer: '',
          answers: [],
          scores: [],
          delay: 800,
          anwersType: 'Number',
          isAssetsAnswers: false,
          questionnaireIds: [],
          answersAndImages: [],
          answersImages: [],
        ),
        Question(
          question: AppLocalizations.of(context)!.wouldYouLikeToLogYourSession,
          answer: '',
          answers: [],
          scores: [],
          delay: 800,
          anwersType: 'Buttons',
          isAssetsAnswers: false,
          questionnaireIds: [],
          answersAndImages: [],
          answersImages: [],
        ),
        Question(
          question: AppLocalizations.of(context)!.howSevereAfter,
          answer: '',
          answers: [],
          scores: [],
          delay: 800,
          anwersType: 'Emoji',
          isAssetsAnswers: true,
          questionnaireIds: [],
          answersAndImages: [
            AnswerAndImage(answer: '1', image: 'terrible'),
            AnswerAndImage(answer: '2', image: 'very-bad'),
            AnswerAndImage(answer: '3', image: 'not-good'),
            AnswerAndImage(answer: '4', image: 'average'),
            AnswerAndImage(answer: '5', image: 'good'),
          ],
          answersImages: [],
        ),
      ],
      score: 5,
      openingMessage: '',
      endMessage: AppLocalizations.of(context)!.goodJob,
    );

    _questionnaires.add(intakeQuestionnaire);
  }

  void resetQuestionnaire(BuildContext context) {
    _questionnaires
        .removeWhere((element) => element.title == 'Intake Questionnaire');

    addIntakeQuestionnaire(context);
  }

  // records

  final List<Record> _records = [];

  List<Record> get records {
    return [..._records];
  }

  Future<void> fetchRecords() async {
    // final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String? userId = globals.chosenPatientId;

    print('qu 1 $userId');

    if (_records.isEmpty) {
      final data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Questionnaires')
          .get();

      final List<QueryDocumentSnapshot> dataList = data.docs;

      for (var record in dataList) {
        final Record newRecord = Record(
          id: record.id,
          answers: Map<String, dynamic>.from(record['answers']),
          date: (record['date'] as Timestamp).toDate().toString(),
          questionnaireId: record['questionnaireId'],
          questionnaireName: record['questionnaireName'],
          isGrams: record['isGrams'],
        );

        _records.add(newRecord);
      }
    }
  }

  Future<void> updateRecord(Record newRecord) async {
    final isRecordExists =
    _records.firstWhereOrNull((element) => element.id == newRecord.id);

    if (isRecordExists == null) {
      _records.add(newRecord);
    }
  }

  void clearData() {
    _records.clear();
    _questionnaires.clear();
    _questions.clear();
  }
}

// import 'dart:convert';
// import 'dart:ui';
// import 'package:collection/collection.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class Question {
//   final String? id;
//   final String question;
//   final List<String>? questionnaireIds;
//   final List<AnswerAndImage> answersAndImages;
//   final List<String>? answers;
//   final List<String> answersImages;
//   final List<int>? scores;
//   final String anwersType;
//   final bool isAssetsAnswers;
//   String answer = '';
//   int delay = 1500;
//
//   Question({
//     this.id,
//     required this.question,
//     required this.answer,
//     required this.answers,
//     required this.scores,
//     required this.delay,
//     required this.anwersType,
//     required this.isAssetsAnswers,
//     required this.questionnaireIds,
//     required this.answersAndImages,
//     required this.answersImages,
//   });
// }
//
// class Questionnaire {
//   final String? id;
//   final String title;
//   final String heTitle;
//   final String description;
//   final List<String>? diseases;
//   final String openingMessage;
//   final String endMessage;
//   final int frequency;
//   final int? score;
//   List<Question> questions;
//
//   Questionnaire({
//     this.id,
//     required this.title,
//     required this.description,
//     required this.diseases,
//     required this.frequency,
//     required this.questions,
//     required this.score,
//     required this.openingMessage,
//     required this.endMessage,
//     required this.heTitle,
//   });
// }
//
// class Record {
//   final String? id;
//   final String questionnaireName;
//   final String questionnaireId;
//   final String date;
//   final bool isGrams;
//   final int score;
//   final Map<String, dynamic> answers;
//
//   Record({
//     this.id,
//     required this.date,
//     required this.questionnaireName,
//     required this.questionnaireId,
//     required this.answers,
//     required this.isGrams,
//     required this.score,
//   });
// }
//
// class AnswerAndImage {
//   final String answer;
//   final String? image;
//
//   AnswerAndImage({
//     required this.answer,
//     required this.image,
//   });
// }
//
// class Questionnaires with ChangeNotifier {
//   // logic
//
//   final List<Questionnaire> _questionnaires = [];
//
//   List<Questionnaire> get questionnaires {
//     return [..._questionnaires];
//   }
//
//   final List<Question> _questions = [];
//
//   List<Question> get questions {
//     return [..._questions];
//   }
//
//   Future<void> fetchQuestionnaires(BuildContext context) async {
//     if (_questionnaires.isEmpty) {
//       Uri url = Uri.parse(
//           'https://api.airtable.com/v0/appoPG6GCqcA06gS3/%D7%A9%D7%90%D7%9C%D7%95%D7%A0%D7%99%D7%9D');
//       Map<String, String> header = {
//         'Authorization': 'Bearer keytTWMXzM0cq89Wh'
//       };
//       http.Response res = await http.get(url, headers: header);
//       var jsonData = jsonDecode(res.body);
//       final List result = jsonData['records'];
//
//       for (Map<String, dynamic> questionnaire in result) {
//         Questionnaire newQuestionnaire = Questionnaire(
//           id: questionnaire['id'],
//           description: questionnaire['fields']['Description'] ?? '',
//           diseases: List<String>.from(
//               questionnaire['fields']['Medical condition'] ?? []),
//           endMessage: '',
//           heTitle: questionnaire['fields']['Questionnaire title - HE'],
//           openingMessage: questionnaire['fields']['Opening message'] ?? '',
//           score: questionnaire['fields']['Score'] ?? 0,
//           title: questionnaire['fields']['Questionnaire title'],
//           frequency: 1,
//           questions: [],
//         );
//
//         _questionnaires.add(newQuestionnaire);
//       }
//
//       addIntakeQuestionnaire(context);
//     }
//   }
//
//   Future<void> fetchQuestions(BuildContext context) async {
//     Locale myLocale = window.locale;
//
//     if (_questions.isEmpty) {
//       Uri url = Uri.parse(
//           'https://api.airtable.com/v0/appoPG6GCqcA06gS3/%D7%A9%D7%90%D7%9C%D7%95%D7%AA?&view=Grid%20view');
//       Map<String, String> header = {
//         'Authorization': 'Bearer keytTWMXzM0cq89Wh'
//       };
//       http.Response res = await http.get(url, headers: header);
//       var jsonData = jsonDecode(res.body);
//
//       final List result = jsonData['records'];
//
//       for (Map<String, dynamic> question in result) {
//         List<dynamic>? imagesData = question['fields']['Images'];
//         List<String>? imageUrls = [];
//
//         if (imagesData != null) {
//           for (var element in imagesData) {
//             if (element['url'] != null) {
//               imageUrls.add(element['url']);
//             }
//           }
//         }
//
//         List<String>? answers =
//         List<String>.from(question['fields']['Answers'] ?? []);
//
//         List<AnswerAndImage> answersAndImages = [];
//
//         int i = 0;
//
//         for (var element in answers) {
//           answersAndImages.add(
//             AnswerAndImage(
//                 answer: element,
//                 image: imageUrls.length > i ? imageUrls[i] : ''),
//           );
//           i++;
//         }
//
//         List<dynamic>? scroses = question['fields']['Score'];
//
//         Question newQuestion = Question(
//          id: question['id'],
//
//           // ignore: prefer_null_aware_operators
//           scores: scroses != null
//               ? scroses.map((data) => int.parse(data)).toList()
//               : null,
//           answer: '',
//           answers: List<String>.from(question['fields']['Answers'] ?? []),
//           question: myLocale.languageCode == 'he'
//               // ? question['fields']['Name -heb']
//               // : question['fields']['Name -en'],
//             ? question['fields']['Questions - HE']
//             : question['fields']['Questions - EN'],
//           questionnaireIds:
//           List<String>.from(question['fields']['Questionnaire'] ?? []),
//           delay: 800,
//           isAssetsAnswers: false,
//           anwersType: question['fields']['Answer type'],
//           answersImages: imageUrls,
//           answersAndImages: answersAndImages,
//         );
//
//         _questions.add(newQuestion);
//
//         for (var id in newQuestion.questionnaireIds!) {
//           final int index =
//           questionnaires.indexWhere((element) => element.id == id);
//           if (index != -1) {
//             questionnaires[index].questions.add(newQuestion);
//           }
//         }
//       }
//     }
//   }
//
//   void addIntakeQuestionnaire(BuildContext context) {
//     // Locale myLocale = window.locale;
//
//     final Questionnaire intakeQuestionnaire = Questionnaire(
//       title: 'Intake Questionnaire',
//       id: 'intakeQuestionnaire',
//       heTitle: 'שאלון צריכה',
//       description: '',
//       diseases: [],
//       frequency: 0,
//       questions: [
//         Question(
//           question: AppLocalizations.of(context)!.howSevereBefore,
//           answer: '',
//           answers: [],
//           scores: [],
//           delay: 800,
//           anwersType: 'Emoji',
//           isAssetsAnswers: true,
//           questionnaireIds: [],
//           answersAndImages: [
//             AnswerAndImage(answer: '1', image: 'terrible'),
//             AnswerAndImage(answer: '2', image: 'very-bad'),
//             AnswerAndImage(answer: '3', image: 'not-good'),
//             AnswerAndImage(answer: '4', image: 'average'),
//             AnswerAndImage(answer: '5', image: 'good'),
//           ],
//           answersImages: [],
//         ),
//         Question(
//           question: AppLocalizations.of(context)!.whatProduct,
//           answer: '',
//           answers: [],
//           scores: [],
//           delay: 800,
//           anwersType: 'PickProduct',
//           isAssetsAnswers: false,
//           questionnaireIds: [],
//           answersAndImages: [],
//           answersImages: [],
//         ),
//         Question(
//           question: AppLocalizations.of(context)!.howMuchConsuming,
//           answer: '',
//           answers: [],
//           scores: [],
//           delay: 800,
//           anwersType: 'Number',
//           isAssetsAnswers: false,
//           questionnaireIds: [],
//           answersAndImages: [],
//           answersImages: [],
//         ),
//         Question(
//           question: AppLocalizations.of(context)!.wouldYouLikeToLogYourSession,
//           answer: '',
//           answers: [],
//           scores: [],
//           delay: 800,
//           anwersType: 'Buttons',
//           isAssetsAnswers: false,
//           questionnaireIds: [],
//           answersAndImages: [],
//           answersImages: [],
//         ),
//         Question(
//           question: AppLocalizations.of(context)!.howSevereAfter,
//           answer: '',
//           answers: [],
//           scores: [],
//           delay: 800,
//           anwersType: 'Emoji',
//           isAssetsAnswers: true,
//           questionnaireIds: [],
//           answersAndImages: [
//             AnswerAndImage(answer: '1', image: 'terrible'),
//             AnswerAndImage(answer: '2', image: 'very-bad'),
//             AnswerAndImage(answer: '3', image: 'not-good'),
//             AnswerAndImage(answer: '4', image: 'average'),
//             AnswerAndImage(answer: '5', image: 'good'),
//           ],
//           answersImages: [],
//         ),
//       ],
//       score: 5,
//       openingMessage: '',
//       endMessage: AppLocalizations.of(context)!.goodJob,
//     );
//
//     _questionnaires.add(intakeQuestionnaire);
//   }
//
//   void resetQuestionnaire(BuildContext context) {
//     _questionnaires
//         .removeWhere((element) => element.title == 'Intake Questionnaire');
//
//     addIntakeQuestionnaire(context);
//   }
//
//   // records
//
//   final List<Record> _records = [];
//
//   List<Record> get records {
//     return [..._records];
//   }
//
//   Future<void> fetchRecords() async {
//     final String userId = FirebaseAuth.instance.currentUser!.uid;
//
//     if (_records.isEmpty) {
//       final data = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(userId)
//           .collection('Questionnaires')
//           .get();
//
//       final List<QueryDocumentSnapshot> dataList = data.docs;
//
//       for (var record in dataList) {
//         final Record newRecord = Record(
//           id: record.id,
//           answers: Map<String, dynamic>.from(record['answers']),
//           date: (record['date'] as Timestamp).toDate().toString(),
//           questionnaireId: record['questionnaireId'],
//           questionnaireName: record['questionnaireName'],
//           isGrams: record['isGrams'],
//           score: record['score'] ?? 0,
//         );
//
//         _records.add(newRecord);
//       }
//     }
//   }
//
//   Future<void> updateRecord(Record newRecord) async {
//     final isRecordExists =
//     _records.firstWhereOrNull((element) => element.id == newRecord.id);
//
//     if (isRecordExists == null) {
//       _records.add(newRecord);
//     }
//   }
//
//   void clearData() {
//     _records.clear();
//     _questionnaires.clear();
//     _questions.clear();
//   }
//
//   double get diseaseScore {
//     double totalScore = 0;
//     if (_records.isNotEmpty) {
//       for (var record in _records) {
//         totalScore += record.score;
//       }
//     }
//     return totalScore;
//   }
// }
