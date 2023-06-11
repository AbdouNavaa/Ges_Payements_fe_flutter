import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/details/prof-cours.dart';
import 'package:flutter_todo_app/details/prof.dart';
import 'package:flutter_todo_app/models/models.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'Methodes.dart';
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Profs extends StatefulWidget {
  // final token;
  const Profs({Key? key}) : super(key: key);

  @override
  State<Profs> createState() => _ProfsState();
}

class _ProfsState extends State<Profs> {
  late MyNewClass _myNewClass = MyNewClass();

  late String userId;
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _banque = TextEditingController();
  TextEditingController _compte = TextEditingController();
  // TextEditingController _id = TextEditingController();
  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodedToken['_id'];
    // _myNewClass.ProfList();
    _myNewClass.ProfList().then((data) {
      setState(() {
        items = data; // Assigner la liste renvoyée par Professeur à items
      });
    }).catchError((error) {
      print('Erreur: $error');
    });
  }

  // Type type = Type(id: id, name: name, coef: coef, taux: taux)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[20],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0,left: 30.0,right: 30.0,bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(child: Drawer(child: Icon(Icons.list),),backgroundColor: Colors.white,radius: 30.0,),
                SizedBox(height: 10.0),
                Text('Gestion de  Payements avec NodeJS + Mongodb',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w300,fontStyle: FontStyle.italic),),
                SizedBox(height: 8.0),
                Center(child: Text('Il y a ${items?.length} Profs',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FutureBuilder<List<Prof>>(
                  future: _myNewClass.Profs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<Prof>? items = snapshot.data;

                        return GridView.builder(
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 60.0,
                            crossAxisSpacing: 5.0,
                          ),
                          itemCount: items!.length,
                          itemBuilder: (context, int index) {
                            return
                              Card(elevation:5,shadowColor: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder:(context) =>  Professeur(ProfId: items![index].id,)));
                                      },
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Image(image:  AssetImage('images/user5.jpg'),width: 170,fit: BoxFit.fill,height: 80),
                                            SizedBox(height: 5,),
                                            // Icon(Icons.emoji_events_outlined),
                                            Text(
                                              '${items![index].nom} ${items![index].prenom}',
                                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                                            ),
                                            // SizedBox(height: 5.0),
                                            // Text(
                                            //   '${items![index]['email']}',
                                            //   style: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                                            // ),

                                            SizedBox(height: 5,),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen,
                                                    padding: EdgeInsets.only(left: 40,right: 40),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                              onPressed: () {

                                                Navigator.push(context, MaterialPageRoute(
                                                    builder:(context) =>  ProfCours(ProfId: items![index].id,ProfName: items![index].nom.toString())));
                                              },
                                              child: Text('Courses' ,style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),)
                                            )
                                          ],
                                        ),
                                      )
                                  )
                              );
                          },
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(margin:EdgeInsets.only(left: 230),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,  elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: () => _displayTextInputDialog(context),
          child: Row(
            children: [
              Icon(Icons.add,size: 30,color: Colors.blue,),
              Text('Ajouter', style: TextStyle(fontSize: 17,fontStyle: FontStyle.italic,color: Colors.blue),)
            ],
          ),
          // tooltip: 'Add Prof',
        ),
      ),
    );
  }


  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add Proffesseur'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _nom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "nom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _prenom,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "prenom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _tel,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Tel",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _banque,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Banque",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),
                  TextField(
                    controller: _compte,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Compte",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  ).p4().px8(),

                  ElevatedButton(onPressed: (){
                    _myNewClass.AddProf(_nom.text,_prenom.text,_email.text,_tel.text,_banque.text,_compte.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Le Prof a été ajouter avec succès.')),
                    );
                    }, child: Text("Add"))
                ],
              ),
            )
          );
        });
  }

}

