import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/Matiere.dart';
import 'package:flutter_todo_app/models/models.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'Methodes.dart';
import 'config.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'models/models.dart';
import 'models/models.dart';

class Cours extends StatefulWidget {
  // final token;
  const Cours({Key? key}) : super(key: key);

  @override
  State<Cours> createState() => _CoursState();
}

class _CoursState extends State<Cours> {

  late String userId;
  TextEditingController _matiere = TextEditingController();
  TextEditingController _prof = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _Deb = TextEditingController();
  TextEditingController _Fin = TextEditingController();
  TextEditingController _CM = TextEditingController();
  TextEditingController _TP = TextEditingController();
  TextEditingController _TD = TextEditingController();
  TextEditingController _total = TextEditingController();
  // TextEditingController _id = TextEditingController();
  List<dynamic>? items;

   num? _selectedCM ;
  num? _selectedTP ;
  num? _selectedTD ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Map<String,dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    // userId = jwtDecodedToken['_id'];
    Courslist();
  }

  late MyNewClass _myNewClass = MyNewClass();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  Future<void> selectDate(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }
  Future<void> selectTime(TextEditingController controller) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTimeWithTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        String formattedDateTime = DateFormat('yyyy/MM/dd HH:mm').format(selectedDateTimeWithTime);
        setState(() {
          controller.text = formattedDateTime;
        });
      }
    }
  }



  void AddCours(String prof,String matiere,DateTime date,DateTime deb,DateTime fin,int CM,int TP, int TD) async {
    final dateFormat = DateFormat('yyyy/MM/dd').format(date);
    final formatteDeb = DateFormat('yyyy/MM/dd HH:mm').format(deb);
    final formattedFin = DateFormat('yyyy/MM/dd HH:mm').format(fin);

   try {
      var regBody = {
        "prof": prof,
        "matiere": matiere,
        "date": dateFormat,
        "Deb": formatteDeb,
        "Fin": formattedFin,
        "CM": CM,
        "TP": TP,
        "TD": TD,
      };

      var response = await http.post(
        Uri.parse(addCours),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print(response.statusCode);
      if (response.statusCode == 201) {
        // _matiere.clear();
        // _prof.clear();
        // _date.clear();
        // _Deb.clear();
        // _Fin.clear();
        // _CM.clear();
        // _TP.clear();
        // _TD.clear();
        Courslist();
      } else {
        print("SomeThing Went Wrong");
      }
    }catch (err) {
     print('Server Error: $err');
   }
  }



  Future<List<Courses>>  Courslist() async {
    // var regBody = {
    //   "userId":userId
    // };

    var response = await http.get(Uri.parse(GetCourses),
      headers: {"Content-Type":"application/json"},
      // body: jsonEncode(regBody)
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      items = jsonResponse;
      List<Courses> cours = [];

      for (var item in jsonResponse) {
        cours.add(
          Courses(
            id: item['_id'],
            prof: item['prof'.text],
            matiere: item['matiere'.text],
            date: item['date'.toDate()],
            deb: item['Deb'.toDate()],
            fin: item['Fin'.toDate()],
            CM: item['CM'],
            TP: item['TP'],
            TD: item['TD'],
            total: item['total'],
          ),
        );
      }

      print(cours);
      setState(() {

      });
      return cours;


    } else {
      throw Exception('Server Error');
    }
  }


  void DeleteProf(id) async{


    var response = await http.delete(Uri.parse(deleteProf + "/$id"),
      headers: {"Content-Type":"application/json"},
      // body: jsonEncode(regBody)
    );

    var jsonResponse = jsonDecode(response.body);
    print(response.statusCode);
    if(response.statusCode ==200){
      Courslist();
    }

  }

  void UpdateProf(id) async {
    if (_matiere.text.isNotEmpty && _prof.text.isNotEmpty && _date.text.isNotEmpty && _Deb.text.isNotEmpty &&
        _Fin.text.isNotEmpty) {
      var regBody = {
        "matiere":_matiere.text,
        "prof":_prof.text,
        "date":_date.text,
        "Deb":_Deb.text,
        "Fin":_Fin.text,
        "CM":_CM.text,
        "TP":_TP.text,
        "TD":_TD.text,
      };

      var response = await http.put(Uri.parse(updateProf + "/$id"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      print(response.statusCode);

      if (response.statusCode == 201) {
        _prof.clear();
        _matiere.clear();
        _date.clear();
        _Deb.clear();
        _Fin.clear();
        _CM.clear();
        // Navigator.pop(context);
        Courslist();
      } else {
        print("Something Went Wrong");
      }
    }
  }
  List? filteredItems;
  MyNewClass myNewClass = MyNewClass();
  // _Matieres matiere = Matieres();

  Prof? _selectedProf; // initialiser le type sélectionné à null
  Matiere? _selectedMatiere; // initialiser le type sélectionné à null

  @override
  Widget build(BuildContext context) {
    //
    // if (items != null) {
    //   DateTime? startDate;
    //   DateTime? endDate;
    //   if (startDateController.text.isNotEmpty) {
    //     startDate = DateFormat('yyyy/MM/dd').parse(startDateController.text);
    //   }
    //   if (endDateController.text.isNotEmpty) {
    //     endDate = DateFormat('yyyy/MM/dd').parse(endDateController.text);
    //   }
    //
    //   filteredItems = items!.where((item) {
    //     final itemDate = DateTime.parse(item.date.toString());
    //     return (startDate == null || itemDate.isAtSameMomentAs(startDate) || itemDate.isAfter(startDate)) &&
    //         (endDate == null || itemDate.isAtSameMomentAs(endDate) || itemDate.isBefore(endDate));
    //   });
    // } else {
    //   filteredItems = null;
    // }
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
               //  SizedBox(height: 5.0),
               //  Text('Gestion de  Payements avec NodeJS + Mongodb',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w300,fontStyle: FontStyle.italic),),
                SizedBox(height: 5.0),
                Center(child: Text('Il y a ${items?.length} Cours',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),

                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          labelText: 'Date de début',
                          border: OutlineInputBorder(),
                        ),
                        // readOnly: true,
                        onTap: () => selectDate(startDateController),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: TextFormField(
                        controller: endDateController ,
                        decoration: InputDecoration(
                          labelText: 'Date de fin',
                          border: OutlineInputBorder(),
                        ),
                        // readOnly: true,
                        onTap: () => selectDate(endDateController),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _total,
                        decoration: InputDecoration(
                          labelText: 'Total',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 10)),
                        ),
                        // Handle date input for end date
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                // SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    // String id = widget.ProfId ?? '';
                    DateTime dateDeb = DateFormat('yyyy/MM/dd').parse(startDateController.text);
                    DateTime dateFin = DateFormat('yyyy/MM/dd').parse(endDateController.text);
                    _myNewClass.getTotals( dateDeb, dateFin).then((total) {
                      setState(() {
                        _total.text = total!.toStringAsFixed(2);
                      });
                    }).catchError((error) {
                      print('Erreur: $error');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,
                    elevation: 10,
                    padding: EdgeInsets.only(left: 120, right: 130),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text('Valider'),
                ),
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
                child: items == null
                    ? Text("Items is null")
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: items!.length,
                  itemBuilder: (context, int index) {
                    // Tri des éléments par ordre croissant de date
                    // items!.sort((a, b) => a.date!..compareTo(b.date!));

                    return SingleChildScrollView(
                      child: Container(
                        width: 250,
                        margin: EdgeInsets.only(top: 5.0,right: 5),

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: Colors.black38,
                              width: 0,
                              style: BorderStyle.solid,
                            ),
                          ),
                          elevation: 20,
                          child: InkWell(
                            onTap: () {
                              // handle onTap
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(height: 10,),
                                Text(
                                  'Prof: ${items![index]['prof']['nom']}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'Matiere: ${items![index]['matiere']['name']}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text('Date:',style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                SizedBox(height: 5.0),
                                Text(
                                  '${DateFormat('yyyy/MM/dd').format(DateTime.parse(items![index]['date'].toString()))}',

                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${DateFormat('HH:mm').format(DateTime.parse(items![index]['Deb'].toString()))} '
                                      'to ${DateFormat('HH:mm').format(DateTime.parse(items![index]['Fin'].toString()))}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                                Text('Equivalence:',style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                Text(
                                  'CM: ${items![index]['CM']} h',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'TP: ${items![index]['TP']} h',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  'TD: ${items![index]['TD']} h',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  '${items![index]['total']!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 25.0),
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
                                                    _myNewClass.DeleteCours(items![index]['_id']);
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
                                        List<Matiere> matieres =await  myNewClass.MatieresList() ;
                                        List<Prof> profs =await  myNewClass.Profs() ;
                                        _selectedProf = items![index]['prof']['id'];
                                        _selectedMatiere = items![index]['matiere']['id'];
                                        _date.text = items![index]['date'];

                                        _Deb.text = items![index]['Deb'];
                                        _Fin.text = items![index]['Fin'];

                                        _selectedCM = items![index]['CM'];
                                        _CM.text = _selectedCM.toString();

                                        _selectedTP = items![index]['TP'];
                                        _TP.text = _selectedTP.toString();

                                        _selectedTD = items![index]['TD'];
                                        _TD.text = _selectedTD.toString();
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
                                                      DropdownButtonFormField<Matiere>(
                                                        value: _selectedMatiere,
                                                        items: matieres.map((matiere) {
                                                          return DropdownMenuItem<Matiere>(
                                                            value: matiere,
                                                            child: Text(matiere.name ?? ''),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedMatiere = value;
                                                          });
                                                        },
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                          hintText: "Matiere",
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                          ),
                                                        ),
                                                      ),
                                                      DropdownButtonFormField<Prof>(
                                                        value: _selectedProf,
                                                        items: profs.map((prof) {
                                                          return DropdownMenuItem<Prof>(
                                                            value: prof,
                                                            child: Text(prof.nom ?? ''),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _selectedProf = value;
                                                          });
                                                        },
                                                        decoration: InputDecoration(
                                                          filled: true,
                                                          fillColor: Colors.white,
                                                          hintText: "Prof",labelText: "Prof",
                                                          border: OutlineInputBorder(
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                          ),
                                                        ),
                                                      ),

                                                      TextFormField(
                                                        controller: _date,
                                                        decoration:
                                                        InputDecoration(labelText: 'Date'),
                                                        onTap: () => selectDate(_date),

                                                      ),
                                                      TextFormField(
                                                        controller: _Deb,
                                                        decoration:
                                                        InputDecoration(labelText: 'Date'),
                                                        onTap: () => selectTime(_Deb),

                                                      ),
                                                      TextFormField(
                                                        controller: _Fin,
                                                        decoration:
                                                        InputDecoration(labelText: 'Date'),
                                                        onTap: () => selectTime(_Fin),

                                                      ),
                                                      TextFormField(
                                                        controller: _CM,
                                                        decoration:
                                                        InputDecoration(labelText: 'CM'),

                                                      ),
                                                      TextFormField(
                                                        controller: _TP,
                                                        decoration:
                                                        InputDecoration(labelText: 'TP'),

                                                      ),
                                                      TextFormField(
                                                        controller: _TD,
                                                        decoration:
                                                        InputDecoration(labelText: 'TD'),

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
                                                    // _taux.text = _selectedCoef.toString(); // ajout de cette ligne
                                                    DateTime date = DateFormat('yyyy/MM/dd').parse(_date.text);
                                                    DateTime Deb = DateFormat('yyyy/MM/dd HH:mm').parse(_Deb.text);
                                                    DateTime Fin = DateFormat('yyyy/MM/dd HH:mm').parse(_Fin.text);
                                                    _myNewClass.UpdateCours(items![index]['_id'],_selectedProf!.id!,_selectedMatiere!.id!,date,Deb,Fin,
                                                        int.parse(_CM.text), int.parse(_TP.text), int.parse(_TD.text));
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(content: Text('Le Type est  Update avec succès.')));
                                                    // );
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
                                SizedBox(height: 25.0),
                              ],
                            ),
                          ),
                        ),
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
    List<Prof> profs = await myNewClass.Profs();
    List<Matiere> matieres = await myNewClass.MatieresList();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Add Cours'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<Matiere>(
                      value: _selectedMatiere,
                      items: matieres.map((type) {
                        return DropdownMenuItem<Matiere>(
                          value: type,
                          child: Text(type.name ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMatiere = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "matiere",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),

                    SizedBox(height: 5,),
                    DropdownButtonFormField<Prof>(
                      value: _selectedProf,
                      items: profs.map((type) {
                        return DropdownMenuItem<Prof>(
                          value: type,
                          child: Text(type.nom ?? ''),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProf = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "prof",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                   SizedBox(height: 5,),
                    TextFormField(
                      controller: _date,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      // readOnly: true,
                      onTap: () => selectDate(_date),
                    ),

                    SizedBox(height: 5,),
                    TextFormField(
                      controller: _Deb,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      // readOnly: true,
                      onTap: () => selectTime(_Deb),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      controller: _Fin,
                      decoration: InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      // readOnly: true,
                      onTap: () => selectTime(_Fin),
                    ),

                    SizedBox(height: 5,),
                    TextField(
                          controller: _CM,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "CM",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ).p4().px8(),
                        TextField(
                          controller: _TP,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "TP",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ).p4().px8(),
                        TextField(
                          controller: _TD,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "TD",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                        ).p4().px8(),

                    ElevatedButton(onPressed: (){
                      DateTime date = DateFormat('yyyy/MM/dd').parse(_date.text);
                      DateTime Deb = DateFormat('yyyy/MM/dd HH:mm').parse(_Deb.text);
                      DateTime Fin = DateFormat('yyyy/MM/dd HH:mm').parse(_Fin.text);

                      AddCours(_selectedProf!.id!, _selectedMatiere!.id!,date,Deb,Fin,
                      int.parse(_CM.text), int.parse(_TP.text), int.parse(_TD.text));
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

