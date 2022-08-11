import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart' as globals;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GarminServices with ChangeNotifier {
  final Map<String, String> _garminSentences = {};

  final Map<String, Map<String, double>> _thcCbdQuantities = {};

  final Map<DateTime, Map<String, int>> _garminStats = {};

  bool isConnected = false;

  Map<String, String> get garminSentences {
    return _garminSentences;
  }

  Map<String, Map<String, double>> get thcCbdQuantities {
    return _thcCbdQuantities;
  }

  Map<DateTime, Map<String, int>> get garminStats {
    return _garminStats;
  }

  Future<void> fetchGarminData(BuildContext context) async {
    garminStats.clear();
    Uri url = Uri.parse(
        'https://api.airtable.com/v0/appoPG6GCqcA06gS3/sentances%20for%20translation?view=Grid%20view');
    Map<String, String> header = {'Authorization': 'Bearer keytTWMXzM0cq89Wh'};
    http.Response res = await http.get(url, headers: header);
    var jsonData = jsonDecode(res.body);
    List result = jsonData['records'];

    for (var item in result) {
      _garminSentences[item['fields']['Name']] =
      item['fields'][AppLocalizations.of(context)!.languageName];
    }

    url = Uri.parse(
        'https://api.airtable.com/v0/appoPG6GCqcA06gS3/Consumption%20parameters?view=Grid%20view');
    header = {'Authorization': 'Bearer keytTWMXzM0cq89Wh'};
    res = await http.get(url, headers: header);
    jsonData = jsonDecode(res.body);
    result = jsonData['records'];

    for (var item in result) {
      final language = AppLocalizations.of(context)?.localeName ?? 'EN';
      _garminSentences[item['fields']['Name - EN'] ?? ''] =
      item['fields']['Name - ${language.toUpperCase()}'];
    }

    url = Uri.parse(
        'https://api.airtable.com/v0/appoPG6GCqcA06gS3/thc%2Fcbd?view=Grid%20view');
    header = {'Authorization': 'Bearer keytTWMXzM0cq89Wh'};
    res = await http.get(url, headers: header);
    jsonData = jsonDecode(res.body);
    result = jsonData['records'];

    for (var item in result) {
      if ((item['fields']['Product type copy'] ?? '') == 'תפרחת') {
        _thcCbdQuantities[
        '${(item['fields']['Product category']) ?? ''}-smoking'] = {
          'THC': double.parse((item['fields']['THC'] ?? 0).toString()),
          'CBD': double.parse((item['fields']['CBD'] ?? 0).toString()),
        };
      } else if ((item['fields']['Product type copy'] ?? '') == 'שמן') {
        _thcCbdQuantities['${(item['fields']['Product category'] ?? '')}-oil'] =
        {
          'THC': double.parse((item['fields']['THC'] ?? 0).toString()),
          'CBD': double.parse((item['fields']['CBD'] ?? 0).toString()),
        };
      }
    }

    // final String user = FirebaseAuth.instance.currentUser?.uid ?? '';
    final String user = globals.chosenPatientId??'';
    print('gar 1 $user');


    try {
      final data = await FirebaseFirestore.instance
          .collection('GarminData')
          .doc(user)
          .get();
      if (data.exists && data.data() != null) {
        Map<String, dynamic> records = data.data()!;
        for (var key in records.keys) {
          if (key == 'firstFetch') continue;
          Map<String, dynamic> value = records[key];
          List<String> date = key.split('-');
          int? year = int.tryParse(date[2]);
          int? month = int.tryParse(date[1]);
          int? dayOfMonth = int.tryParse(date[0]);
          if (year == null || month == null || dayOfMonth == null) continue;
          DateTime day = DateTime(year, month, dayOfMonth);
          _garminStats[day] = {
            'restingHr': value['restingHeartRate'] ?? 0,
            'sleep': value['sleepRange'] ?? 0,
            'steps': value['steps'] ?? 0,
          };
        }
      }
    } catch (e) {
      print('Error fetching garmin data: $e');
    }
  }

  Future<bool> checkIfUserHaveGarmin() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    // final  userId = globals.chosenPatientId??'';

    print('gar 2 $userId');

    if (userId == '') return false;
    try {
      final data = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .get();
      if (data.data()!.containsKey('garmin')) return true;
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> checkIfUserGarminConnected() async {
    http.Response? response;
    print('gar 3 ${FirebaseAuth.instance.currentUser?.uid}');

    try {
      final uri = Uri.parse('http://185.151.199.148:3000/isLogin');
      response = await http.post(uri,
          body: {'userId': FirebaseAuth.instance.currentUser?.uid/*globals.chosenPatientId*/??''});
    } catch (e) {
      isConnected = false;
      return;
    }
    if (response.statusCode == 200 && response.body == 'true') {
      isConnected = true;
    }
  }

  Future<void> signOut() async {
    isConnected = false;
    print('gar 4 ${FirebaseAuth.instance.currentUser?.uid}');

    final uri = Uri.parse('http://185.151.199.148:3000/signOut');
    await http.post(uri,
        body: {'userId': FirebaseAuth.instance.currentUser?.uid/*globals.chosenPatientId*/ ?? ''});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid/*globals.chosenPatientId*/ ?? '')
        .update({'isFirstLogin': true});
    await FirebaseFirestore.instance
        .collection('GarminData')
        .doc(FirebaseAuth.instance.currentUser?.uid/*globals.chosenPatientId*/ ?? '')
        .delete();
  }
}