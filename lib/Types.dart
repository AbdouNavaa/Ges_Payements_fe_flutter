import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Matiere.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'Methodes.dart';
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'models/models.dart';

class Types extends StatefulWidget {
  const Types({Key? key}) : super(key: key);

  @override
  State<Types> createState() => _TypesState();
}

class _TypesState extends State<Types> {
  late MyNewClass _myNewClass = MyNewClass();
  late String userId;
  TextEditingController _name = TextEditingController();
  TextEditingController _taux = TextEditingController();
  late List items;

  TextEditingController _tauxController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // _myNewClass = MyNewClass();
    _myNewClass.TypesList();

  }

  // Type type = Type(id: id, name: name, coef: coef, taux: taux)
  int _selectedTaux = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: (){

                      Navigator.pop(context);
                    }, child: Row(
                      children: [
                        Icon(Icons.call_received),
                        Text("Matieres"),
                      ],
                    ), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),)
                  ],
                )
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
                child: FutureBuilder<List<MatiereType>>(
                  future: _myNewClass.TypesList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<MatiereType>? items = snapshot.data;
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
                              Card(elevation: 5,margin: EdgeInsets.symmetric(vertical: 1,horizontal: 10),shadowColor: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: InkWell(
                                onTap: () {
                              // handle onTap
                            },
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(
                            '${items![index].name}',
                            style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                            '${items![index].taux}',
                            style: TextStyle(fontSize: 16.0,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                            ),
                              SizedBox(height: 20,),

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
                            _myNewClass.DeleteType(items![index].id);
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Le Type a été Supprimer avec succès.')),
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
                              _name.text = items![index].name!;
                            _selectedTaux = items![index].taux!;
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
                            controller: _name,
                            decoration:
                            InputDecoration(labelText: 'Name'),
                            ),
                            DropdownButtonFormField<int>(
                            value: _selectedTaux,
                            items: [
                            DropdownMenuItem<int>(
                            child: Text('500'),
                            value: 500,
                            ),
                            DropdownMenuItem<int>(
                            child: Text('900'),
                            value: 900,
                            ),
                            ],
                            onChanged: (value) {
                            setState(() {
                            _selectedTaux = value!;
                            });
                            },
                            decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "taux",
                            border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            ),
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
                            _taux.text = _selectedTaux.toString(); // ajout de cette ligne
                            _myNewClass.UpdateType(items![index].id!,_name.text,_selectedTaux);
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Le Type est  Update avec succès.')),
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
                            )
                            ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add Prof',
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    // int _selectedTaux = 500;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Type'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _name,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ).p4().px8(),
                DropdownButtonFormField<int>(
                  value: _selectedTaux,
                  items: [
                    DropdownMenuItem<int>(
                      child: Text('500'),
                      value: 500,
                    ),
                    DropdownMenuItem<int>(
                      child: Text('900'),
                      value: 900,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTaux = value!;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "taux",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {//
                    _taux.text = _selectedTaux.toString(); // ajout de cette ligne
                    _myNewClass.AddType(_name.text,_selectedTaux);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Le Type a été ajouter avec succès.'),
                      ),
                    );
                  },
                  child: Text("Add"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


