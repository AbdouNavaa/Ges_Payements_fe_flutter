import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Types.dart';
import 'package:flutter_todo_app/models/models.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'Methodes.dart';
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Matieres extends StatefulWidget {
  // final token;
  const Matieres({Key? key}) : super(key: key);

  @override
  State<Matieres> createState() => _MatieresState();
}

class _MatieresState extends State<Matieres> {

  late String userId;
  TextEditingController _name = TextEditingController();
  TextEditingController _coef = TextEditingController();
  TextEditingController _taux = TextEditingController();
  List<dynamic>? items;
  MyNewClass myNewClass = MyNewClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodedToken['_id'];
    MatieresList();
  }

  void AddMatiere(String name, int coef, String taux) async {
    if (_name.text.isNotEmpty && _selectedType!.name!.isNotEmpty) {
      var regBody = {
        "name": name,
        "coef": coef,
        "taux": taux, // Convertir le taux en entier
      };

      var response = await http.post(
        Uri.parse(addMat),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print(response.statusCode);
      if (response.statusCode == 201) {
        _taux.clear();
        _coef.clear();
        _name.clear();
        MatieresList();
      } else {
        print("SomeThing Went Wrong");
      }
    }
  }


  Future<List<Matiere>>  MatieresList() async {
    // var regBody = {
    //   "userId":userId
    // };

    var response = await http.get(Uri.parse(GetMatieres),
      headers: {"Content-Type":"application/json"},
      // body: jsonEncode(regBody)
    );

print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      items = jsonResponse;
      List<Matiere> matieres = [];

      for (var item in jsonResponse) {
        matieres.add(
          Matiere(
            id: item['_id'],
            name: item['name'],
            coef: item['coef'],
            taux: item['taux'].toString(),
          ),
        );
      }

      print(matieres);
      setState(() {

      });
      return matieres;


    } else {
      throw Exception('Server Error');
    }
  }

  late MyNewClass _myNewClass = MyNewClass();

  MatiereType? _selectedType; // initialiser le type sélectionné à null

  int _selectedCoef = 3;

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
                    Center(child: Text('Il y a ${items?.length} Matieres',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),
                    ElevatedButton(onPressed: (){

                      Navigator.push(context, MaterialPageRoute(
                          builder:(context) =>  Types()));
                    }, child: Row(
                      children: [
                        Text("Types"),
                        Icon(Icons.send),
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
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: items == null ? Text("Items is null") : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 60.0,
                    crossAxisSpacing: 5.0,
                  ),

                  itemCount: items!.length,
                  itemBuilder: (context, int index) {
                    return Card(elevation: 5,margin: EdgeInsets.symmetric(vertical: 1,horizontal: 15),shadowColor: Colors.blue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                          onTap: () {
                            // handle onTap
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.emoji_events_outlined),
                              Text(
                                '${items![index]['name']}',
                                style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '${items![index]['coef']}',
                                style: TextStyle(fontSize: 14.0,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                              ),

                              Text(
                                '${items![index]['taux']['name']}',
                                style: TextStyle(fontSize: 14.0,fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),

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
                                            actions: [
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
                                                  _myNewClass.DeleteMatiere(items![index]['_id']);
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
                                    onPressed: () async{
                                      List<MatiereType> types =await  myNewClass.TypesList() ;
                                      _name.text = items![index]['name'];
                                      _selectedCoef = items![index]['coef'];
                                      _selectedType = items![index]['taux']['id'];
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
                                                      value: _selectedCoef,
                                                      items: [
                                                        DropdownMenuItem<int>(
                                                          child: Text('3'),
                                                          value: 3,
                                                        ),
                                                        DropdownMenuItem<int>(
                                                          child: Text('4'),
                                                          value: 4,
                                                        ),
                                                      ],
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedCoef = value!;
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
                                                    DropdownButtonFormField<MatiereType>(
                                                      value: _selectedType,
                                                      items: types.map((type) {
                                                        return DropdownMenuItem<MatiereType>(
                                                          value: type,
                                                          child: Text(type.name ?? ''),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _selectedType = value;
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
                                                  _taux.text = _selectedCoef.toString(); // ajout de cette ligne
                                                  _myNewClass.UpdateMatiere(items![index]['_id'],_name.text,_selectedCoef,_selectedType!.id!);
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

                      ),
                    );
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
    List<MatiereType> types = await myNewClass.TypesList();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Matiere'),
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
                  value: _selectedCoef,
                  items: [
                    DropdownMenuItem<int>(
                      child: Text('3'),
                      value: 3,
                    ),
                    DropdownMenuItem<int>(
                      child: Text('4'),
                      value: 4,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCoef = value!;
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


                // Afficher la liste des types
                DropdownButtonFormField<MatiereType>(
                  value: _selectedType,
                  items: types.map((type) {
                    return DropdownMenuItem<MatiereType>(
                      value: type,
                      child: Text(type.name ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
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
                  onPressed: () {
                      _coef.text = _selectedCoef.toString();
                      AddMatiere(_name.text,_selectedCoef,_selectedType!.id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('La matière a été ajoutée avec succès.'),
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

