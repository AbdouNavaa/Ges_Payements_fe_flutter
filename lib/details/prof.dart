import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/details/prof-cours.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Methodes.dart';

class  Professeur extends StatefulWidget {
  // final token;
  const  Professeur({Key? key, required this.ProfId}) : super(key: key);

  final String? ProfId;
  @override
  State< Professeur> createState() => _ProfesseurState();
}

class _ProfesseurState extends State< Professeur> {
  late MyNewClass _myNewClass = MyNewClass();

  late String userId;
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _banque = TextEditingController();
  TextEditingController _compte = TextEditingController();
  // TextEditingController _id = TextEditingController();
  late List<Map<String, dynamic>>? items; // Modifier le type de la liste

  @override
  void initState() {
    super.initState();
    _myNewClass.Professeur(widget.ProfId).then((data) {
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
      backgroundColor: Colors.grey[100],
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
                // Center(child: Text('Il y a ${items?.length}  Professeur',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),
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
                child: FutureBuilder(
                  future: _myNewClass.Professeur(widget.ProfId),
                    builder: (context, snapshot) {
                      List<Map<String, dynamic>>? items = snapshot.data;
                      print(snapshot.data);
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, i){
                              return SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children:[
                                      Text(snapshot.data![i]['nom']+ ' Details: ', style: TextStyle(fontSize: 30,fontStyle: FontStyle.italic),),
                                      Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(30),side: BorderSide(color: Colors.black12,
                                            strokeAlign: StrokeAlign.inside,width: 1),),
                                        elevation: 30,
                                        child: Container(

                                          width: MediaQuery.of(context).size.width /1.2,
                                          height: MediaQuery.of(context).size.height/ 2.5,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                        image: AssetImage('images/user1.png'),width: 100,
                                                  ),
                                                  Text(snapshot.data![i]['nom'],style: TextStyle(fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 25,color: Colors.green)),
                                                SizedBox(width: 5,),
                                                Text(snapshot.data![i]['prenom'],style: TextStyle(fontWeight: FontWeight.w700,fontStyle: FontStyle.italic,fontSize: 25)),
                                              ],),
                                              Text('Email: '+snapshot.data![i]['email']),
                                              Text('Telephone: '+snapshot.data![i]['tel'].toString()),
                                              Text('Banque: '+snapshot.data![i]['Banque']),
                                              Text('Compte: '+snapshot.data![i]['Compte']),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Confirmer la suppression"),
                                                            content: Text(
                                                                "Êtes-vous sûr de vouloir supprimer cet élément ?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: Text("ANNULER"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  "SUPPRIMER",
                                                                  style: TextStyle(color: Colors.red),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  _myNewClass.DeleteProf(snapshot.data![i]['_id']);
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text('Le Prof a été Supprimer avec succès.')),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.delete_outline),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.red,
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      _nom.text = snapshot.data![i]['nom'];
                                                      _prenom.text =snapshot.data![i]['prenom'];
                                                      _email.text =snapshot.data![i]['email'];
                                                      _tel.text =snapshot.data![i]['tel'].toString();
                                                      _banque.text =snapshot.data![i]['Banque'];
                                                      _compte.text =snapshot.data![i]['Compte'].toString();

                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: Text("Mise à jour de la tâche"),
                                                            content: Form(
                                                              child: SingleChildScrollView(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    TextFormField(
                                                                      controller: _nom,
                                                                      decoration:
                                                                      InputDecoration(labelText: 'Nom'),
                                                                    ),
                                                                    TextFormField(
                                                                      controller: _prenom,
                                                                      decoration: InputDecoration(
                                                                          labelText: 'Prenom'),
                                                                    ),

                                                                    TextFormField(
                                                                      controller: _email,
                                                                      decoration: InputDecoration(
                                                                          labelText: 'Email'),
                                                                    ),
                                                                    TextFormField(
                                                                      controller: _tel,
                                                                      decoration: InputDecoration(
                                                                          labelText: 'Tel'),
                                                                    ),
                                                                    TextFormField(
                                                                      controller: _banque,
                                                                      decoration: InputDecoration(
                                                                          labelText: 'Banque'),
                                                                    ),
                                                                    TextFormField(
                                                                      controller: _compte,
                                                                      decoration: InputDecoration(
                                                                          labelText: 'Compte'),
                                                                    ),


                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                child: Text("ANNULER"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  "MISE À JOUR",
                                                                  style: TextStyle(color: Colors.blue),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  _myNewClass.UpdateProf(snapshot.data![i]['_id'],_nom.text,_prenom.text,_email.text,_tel.text,_banque.text,_compte.text);
                                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                                    SnackBar(content: Text('Le Prof est  Update avec succès.')),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(Icons.edit_note_sharp,color: Colors.black,),
                                                    style: ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(width:290,
                                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(margin:EdgeInsets.only(right: 5,top: 5),height: 55,
                                              child: ElevatedButton(
                                                onPressed: (){

                                                  Navigator.pop(context);
                                                }, child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Icon(Icons.arrow_back_ios,color: Colors.green),
                                                  Text("Back", style: TextStyle(color: Colors.green),),
                                                ],
                                              ),
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,
                                                  padding: EdgeInsets.only(left: 30,right: 30),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),elevation: 20),),
                                            ),
                                            Container(margin:EdgeInsets.only(left: 15,top: 5),height: 55,
                                              child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white,foregroundColor: Colors.black,
                                                      padding: EdgeInsets.only(left: 25,right: 25),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),elevation: 20,shadowColor: Colors.black),
                                                  onPressed: () {

                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder:(context) =>  ProfCours(ProfId: widget.ProfId,ProfName: snapshot.data![i]['nom'])));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text('Courses',style: TextStyle(color: Colors.green), ),
                                                      Icon(Icons.arrow_forward_ios,color: Colors.green),
                                                    ],
                                                  )
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            });
                      }else{return Text('Null');
                      }
                    }),
              ),
            ),
          ),
        ],
      ),

    );
  }



}

