import 'package:flutter/material.dart';

class PersonalDetails extends StatelessWidget
{

 final String mail;

  const PersonalDetails({super.key, required this.mail});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top:50,right: 10,left: 10 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
   children: [
     Row(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [Text('פרטים אישיים',style: TextStyle(
         fontSize: 20,
         color:Color.fromRGBO(78, 122, 199, 1),
         fontWeight: FontWeight.w900
       ),),
      ],
     ),
     Padding(padding: EdgeInsets.only(top: 20),
         child: Text(mail,style: TextStyle(fontSize: 18)))
   ],
      ),
    );
  }

}