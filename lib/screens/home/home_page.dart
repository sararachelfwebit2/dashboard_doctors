import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_doctors/animations/fade_transition.dart';
import 'package:dashboard_doctors/colors.dart';
import 'package:dashboard_doctors/models/bar.dart';
import 'package:dashboard_doctors/models/consumption_record.dart';
import 'package:dashboard_doctors/models/product.dart';
import 'package:dashboard_doctors/models/questionnaire.dart';
import 'package:dashboard_doctors/models/user.dart';
import 'package:dashboard_doctors/models/week_bar.dart';
import 'package:dashboard_doctors/screens/home/home_page.dart';
import 'package:dashboard_doctors/screens/login/login_page.dart';
import 'package:dashboard_doctors/services/garmin_services.dart';
import 'package:dashboard_doctors/widgets/consumption_graph.dart';
import 'package:dashboard_doctors/widgets/consumption_table.dart';
import 'package:dashboard_doctors/widgets/home/chat_doctor/chat.dart';
import 'package:dashboard_doctors/widgets/home/graph.dart';
import 'package:dashboard_doctors/widgets/home/measures.dart';
import 'package:dashboard_doctors/widgets/home/personalDeatails.dart';
import 'package:dashboard_doctors/widgets/home/records/records_grid.dart';
import 'package:dashboard_doctors/widgets/home/user_list.dart';
import 'package:dashboard_doctors/widgets/webImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/app_icon.dart';
import '../../globals.dart' as globals;

class HomePage extends StatefulWidget {

  final String name;

  static bool isNewUser=false;
  HomePage({Key? key,this.name=''}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime now =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late final List<ConsumptionRecord> records = [];
  late final List<Bar> bars = [];
  late final List<WeekBar> weekBars = [];
  int duration = 7;
  bool isLoadingQ = true;
  bool isLoadingPatients = true;
  bool garminConnected = false;
  List<DateTime> presentWeek = [];
  late User chossenUser;
  late UserList userList;

  Bar? clickedBar;

  List<String> months = [];
  List<DateTime> presentMonth = [];
  String? chosenMonth;

  WeekBar? clickedWeekBar;
  late List<UserStats> myUsers;
  late List<Record> recordsQ=[];
  bool isShowingMonth = false;
  late final Products productsModel ;
  late final Questionnaires questionnaireModel;
  late final garminServices;
 late String  ?chosenPatientMail;


  @override
  void initState() {
    productsModel = Provider.of<Products>(context, listen: false);
    questionnaireModel = Provider.of<Questionnaires>(context, listen: false);
     garminServices = Provider.of<GarminServices>(context, listen: false);

    getAllPatients();

    chosenMonth= garminServices.garminSentences['ChooseMonth'] ?? 'Choose month';
     isShowingMonth = !(chosenMonth ==
        (garminServices.garminSentences['ChooseMonth'] ?? 'Choose month'));

     getQuestionnaires();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 print(' home page build');
    var screenSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection:  TextDirection.ltr,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            //adding an Appbar
            // backgroundColor: Colors.lightBlue[600],
            title: Row(
              children: [
                OutlinedButton(
                  child: Text('התנתק', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (Route<dynamic> route) => false);
                    // Navigator.pop(context);
                  },
                ),
                Container(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                     widget.name,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))
              ],
            ),
            //the name of the application
            actions: [
              // the actions widget allows us to add several navigation items
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 30, top: 10),
                  child: Image.asset(
                    // 'assets/icons/leema-icon.png',
                    'assets/icons/leema-logo.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              )
            ],
          ),
          body:  isLoadingPatients || isLoadingQ
              ? const Center(
            child: CircularProgressIndicator(),
          ) :Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Container(
                        width: screenSize.width * 0.25,
                        color: const Color.fromRGBO(234, 240, 254, 1),
                        child: Column(
                          children: [
                            PersonalDetails(mail: chosenPatientMail??''),
                            SizedBox(height: 20),
                             Expanded(child:  Chat( ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          // do not add const , make problems in state
                          child: Measure()
                          // child: ListView(
                          //   controller: ScrollController(),
                          //   // crossAxisAlignment: CrossAxisAlignment.start,
                          //   // mainAxisSize: MainAxisSize.max,
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.only(top: 30),
                          //       child: Text('המטופל ביחס לטיפול',
                          //           style: TextStyle(
                          //               color: Color.fromRGBO(78, 122, 199, 1),
                          //               fontSize: 20,
                          //               fontWeight: FontWeight.w600)),
                          //     ),
                         // Measure()
                         //    ],
                         // ),
                        ),
                      ),
                      Container(
                        width: screenSize.width * 0.25,
                        color: MyColors.backgroundColor,
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            Text('שאלונים אחרונים',style: TextStyle(
                  color: Color.fromRGBO(78, 122, 199, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
                            Expanded(
                                child: RecordsGrid(records: recordsQ)
                            ),
                            Expanded(
                                child: userList)
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ),
    );
  }

  Future<void> getAllPatients() async {
    final data = await FirebaseFirestore.instance.collection("Users").get();

    print("length ${data.docs.length}");
    // DocumentSnapshot document = data.docs[0];
    // print('ggg ' + document['email']);

    // globals.chosenPatientId= listUser.where((element) => element.id=='aKlMIacPx9TQOeVb3cDFWZOfRpf2') as String?;

      myUsers=[];

    for(DocumentSnapshot user in data.docs)
      {
         myUsers.add(UserStats(user.id,user['email'], await checkGarmin(user.id)));
      }
    globals.chosenPatientId=myUsers[0].id;
    chosenPatientMail=myUsers[0].email;
    print('hhhh ${globals.chosenPatientId}');
    userList=UserList(
        myUsers:  myUsers,
        onChoose:(user,mail){
          setChosenPatient(user,mail);});
    getQuestionnaires();
    isLoadingPatients=false;

    // setState(() {});
  }

 Future<bool> checkGarmin(String userId) async
  {
    try {
      final data = await FirebaseFirestore.instance
          .collection('GarminData')
          .doc(userId)
          .get();
      if (data.exists && data.data() != null) {
        Map<String, dynamic> records = data.data()!;
        DateTime now= DateTime.now();
        DateTime yesterdayDate= DateTime.now().subtract(const Duration(hours: 24));
        String today= '${now.day}-${now.month}-${now.year}';
        String yesterday= '${yesterdayDate.day}-${yesterdayDate.month}-${yesterdayDate.year}';
   //  print('today $today');
   //  print('yesterday $yesterday');

        for (var key in records.keys) {
          if (key == 'firstFetch') continue;

          if(key==today || key==yesterday)
            {

              return true;
            }
        }

       }

      return false;
    }
     catch (e) {
      print('Error fetching garmin data: $e');
      return false;
    }

  }


  Bar? findDay(DateTime day, List<Bar> barss) {
    for (var bar in barss) {
      if (bar.dateTime.day == day.day &&
          bar.dateTime.month == day.month &&
          bar.dateTime.year == day.year) {
        return bar;
      }
    }
    return null;
  }

  WeekBar? findWeek(DateTime day, List<WeekBar> barss) {
    for (var bar in barss) {
      if (bar.dateTime.start.isBefore(day) && bar.dateTime.end.isAfter(day)) {
        return bar;
      }
    }
    return null;
  }

  void setClickedBar(Bar bar) {
    clickedBar = bar;
    setState(() {});
  }

   setChosenPatient(String id,String mail)
  {
    //setState is called when getQuestionnaires is fetched
  //   setState(() {
       globals.chosenPatientId=id;
       HomePage.isNewUser=true;
       chosenPatientMail=mail;
       print("jjj ${globals.chosenPatientId}");
       isLoadingQ=true;
       questionnaireModel.clearData();
       getQuestionnaires();
  //   });
  }

  Future<void>  getQuestionnaires()  async{
    recordsQ.clear();
    print('===getQuestionnaires===');
    await questionnaireModel.fetchRecords();
     for (var record in questionnaireModel.records
         .where(
             (element) => element.questionnaireName == 'Intake Questionnaire')
         .toList()) {

         if (!recordsQ.contains(record)) {
           recordsQ.add(record);
         }
       }
     isLoadingQ=false;
     setState(() {});
     }
   }

