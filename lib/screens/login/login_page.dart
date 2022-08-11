import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animations/fade_transition.dart';
import '../../widgets/authTextField.dart';
import '../home/home_page.dart';
import './continueButton.dart';

class LoginPage extends StatefulWidget
{
  final TextEditingController emailController= new TextEditingController();
  final TextEditingController passwordController= new TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();


  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  /// Determine the color of the visibility icon.
  bool passwordVisibility = false;
  late UserCredential userCredential;
  String emailAddress = '';
  String password = '';
  String validationText='';
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.collection("Users").
    // doc("aKlMIacPx9TQOeVb3cDFWZOfRpf2").get().then((value) => print(value.exists));
    return Scaffold(
      appBar: AppBar(
        //adding an Appbar
        // backgroundColor: Colors.lightBlue[600],
          title: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    // 'assets/icons/leema-icon.png',
                    'assets/icons/leema-logo.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              )
          ),
     body: isLoading
         ? const Center(
       child: CircularProgressIndicator(),
     ): Form(
       key: widget.formKey,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.start,
         children: [
           const SizedBox(height: 30),
           Center(
             child: Image.asset(
               'assets/icons/leema-logo.png',
               width: 250,
               height: 250,
               color: const Color.fromARGB(188, 44, 100, 197),
             ),
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 550),
             child: AuthTextField(
               controller: widget.emailController,
               hintText: 'הכנס כתובת מייל',
               onSaved: onSaved,
               parameter: 'כתובת מייל',
               validationText: 'הכנס כתובת מייל תקינה',
               label: 'כתובת מייל',
             ),
           ),
           const SizedBox(
             height: 20,
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 550),
             child: AuthTextField(
               controller: widget.passwordController,
               hintText: 'הכנס סיסמא',
               onSaved: onSaved,
               parameter: 'סיסמא',
               label: 'סיסמא',
               validationText: 'הכנס סיסמא תקינה',
             ),
           ),
           const SizedBox(
             height: 20,
           ),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 550),
             child: ContinueButton(
               onPressed: tryLogin,
               buttonText: 'התחבר',
             ),
           ),
           if (validationText != '')
             const SizedBox(
               height: 10,
             ),
           Text(
             validationText,
             style: const TextStyle(
               color: Colors.red,
               fontSize: 16,
             ),
           ),
         ],
       ),
     )

    );
  }

  Future<void> tryLogin() async {
    validationText='';
    setState(() {});
    if (!widget.formKey.currentState!.validate()) {
      // Invalid
      return;
    }
try {
  isLoading = true;
  setState(() {});
  userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: widget.emailController.text.toString(),
      password: widget.passwordController.text.toString());
}on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
   validationText = 'הנתונים שהזנת אינם מאפשרים גישה למערכת';
  isLoading = false;
  setState(() {});
  return;
}
    print("id ${userCredential.user?.uid}");
 final data=await FirebaseFirestore.instance.collection("Users").
  doc(userCredential.user?.uid).get();
  print("id ${data.id}");
  if (data.data()!.containsKey('userSuperAdmin')
  && data['userSuperAdmin'].toString()=='true')
    {
      String name='';
      if(data.data()!.containsKey('userSuperAdmin'))
        {
           name=data['name'];
        }
      Navigator.of(context)
          .pushReplacement( MaterialPageRoute(builder: (BuildContext context) => HomePage(name: name)));
      return;
    }
  validationText = 'הנתונים שהזנת אינם מאפשרים גישה למערכת';
  isLoading = false;
  setState(() {});
  await FirebaseAuth.instance.signOut();

    // .then((value) {
  //  Map<String, dynamic> map = doc.data();
  //  if(map.containsKey("userSuperAdmin"))
  //  {
  //    print('ttttttttt');
  //    print( map['userSuperAdmin']);
  //    if(map['userSuperAdmin'].toString()=='true')
  //      Navigator.of(context)
  //          .pushReplacement(FadeTransiton( HomePage(), 800));
  //  }
  //  else
  //  {
  //    print('jjjjj');
  //
  //  }
  //   print(value.id);});
  // final userProvider = Provider.of<User>(context, listen: false);
  // print('email: ${data['email']}');
  // print('name: ${data['name']}');
  // print('imageUrl: ${data['imageUrl']}');
  // print('gender: ${data['gender']}');
  // print('weight: ${data['weight']}');
  // print('birth: ${data['birth']}');
  // print('reasonForSmoking: ${data['reasonForSmoking']}');
  // print('amountOfSmoking: ${data['amountOfSmoking']}');
  // print('awakeTime: ${data['awakeTime']}');
  // print('sleepTime: ${data['sleepTime']}');
//   Map<String, dynamic> map = doc.data();
//   if(map.containsKey("userSuperAdmin"))
//     {
//       print('ttttttttt');
//       print( map['userSuperAdmin']);
//     if(map['userSuperAdmin'].toString()=='true')
//       Navigator.of(context)
//           .pushReplacement(FadeTransiton( HomePage(), 800));
//     }
// else
//   {
//     print('jjjjj');
//
//   }
  // print('userSuperAdmin: ${data['userSuperAdmin']?? 'lll'}');
  // if(data['userSuperAdmin']==null|| data['userSuperAdmin'].toString()=='false')
  //   {
  //     validationText = 'הנתונים שהזנת אינםO מאפשרים גישה למערכת';
  //     // isLoading = false;
  //     setState(() {});
  //     return;
  //   }


  // userProvider.email = data['email'] ?? '';
  // userProvider.name = data['name'] ?? '';
  // userProvider.imageUrl = data['imageUrl'] ?? '';
  // userProvider.gender = data['gender'] ?? '';
  // userProvider.weight = data['weight'] ?? 0;
  // userProvider.birth = data['birth'] ?? '';
  // userProvider.
  }

  void onSaved(value, parameter) {
    switch (parameter) {
      case 'email':
        emailAddress = value;
        break;
      case 'password':
        password = value;
    }
  }
}

//לבדוק לוגין לפי
// await FirebaseAuth.instance.signInWithEmailAndPassword
//לuserCredential   אכ נכנס ה id של המשתמש
// אחרת null
//לקבל את המשתמש
//FirebaseFirestore.instance.collection("Users").
//     doc("aKlMIacPx9TQOeVb3cDFWZOfRpf2").get()
//משהו כזה  ולבדוק האם admin
// אם לא אדמין לנתק אותו מה firebasse
