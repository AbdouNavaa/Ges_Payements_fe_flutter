import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'package:intl/intl.dart';

import 'models/models.dart';



class MyNewClass {
  late String userId;
  TextEditingController _name = TextEditingController();
  TextEditingController _taux = TextEditingController();
  TextEditingController _nom = TextEditingController();
  TextEditingController _prenom = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _tel = TextEditingController();
  TextEditingController _banque = TextEditingController();
  TextEditingController _compte = TextEditingController();
  List? items;

  TextEditingController _tauxController = TextEditingController();

  Future<void> AddType(String name, int taux) async {
    final response = await http.post(
      Uri.parse(addType),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'taux': taux,
      }),
    );
    if (response.statusCode == 201) {
            _taux.clear();
            _name.clear();
             TypesList();
          } else {
            print("SomeThing Went Wrong");
          }
  }


  Future<List<MatiereType>> TypesList() async {
    try {
      var response = await http.get(Uri.parse(GetTypes),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<MatiereType> types = [];

        for (var item in jsonList) {
          types.add(
            MatiereType(
              id: item['_id'],
              name: item['name'],
              taux: item['taux'],
            ),
          );
        }

        return types;
      } else {
        throw Exception('Server Error');
      }
    } catch (e) {
      throw Exception(e.toString());
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
      // setState(() {
      //
      // });
      return matieres;


    } else {
      throw Exception('Server Error');
    }
  }

  void DeleteType(id) async {
    var response = await http.delete(Uri.parse(deleteType + "/$id"),
      headers: {"Content-Type": "application/json"},
    );

    var jsonResponse = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      TypesList();
    }
  }
  void DeleteMatiere(id) async {
    var response = await http.delete(Uri.parse(deleteMat + "/$id"),
      headers: {"Content-Type": "application/json"},
    );

    var jsonResponse = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      TypesList();
    }
  }
  void DeleteCours(id) async {
    var response = await http.delete(Uri.parse(deleteCours + "/$id"),
      headers: {"Content-Type": "application/json"},
    );

    var jsonResponse = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      // TypesList();
      print('Le Cours est supprimer');
    }
  }

  Future<void> UpdateType(String id, String name, int taux) async {
    final response = await http.put(
      Uri.parse(updateType + "/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'taux': taux,
      }),
    );
    if (response.statusCode == 201) {
       TypesList();
      print(response.statusCode);
      return jsonDecode(response.body);
    } else {
      return Future.error('Server Error');
      print(
          '4e 5asser sa77bi mad5al======================================');
    }
  }
  Future<void> UpdateMatiere(String id, String name,int coef, String taux) async {
    final response = await http.put(
      Uri.parse(updateMat + "/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'coef': coef,
        'taux': taux,
      }),
    );
    if (response.statusCode == 201) {
       // TypesList();
      print(response.statusCode);
      return jsonDecode(response.body);
    } else {
      print(
          '4e 5asser sa77bi mad5al======================================');
      return Future.error('Server Error');

    }
  }
  Future<void> UpdateCours(String id, String prof,String matiere,DateTime date,DateTime deb,DateTime fin,int CM,int TP, int TD) async {
    final dateFormat = DateFormat('yyyy/MM/dd').format(date);
    final formatteDeb = DateFormat('yyyy/MM/dd HH:mm').format(deb);
    final formattedFin = DateFormat('yyyy/MM/dd HH:mm').format(fin);

    try {

      final response = await http.put(
      Uri.parse(updateCours + "/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "prof": prof,
        "matiere": matiere,
        "date": dateFormat,
        "Deb": formatteDeb,
        "Fin": formattedFin,
        "CM": CM,
        "TP": TP,
        "TD": TD,
      }),
    );
    if (response.statusCode == 201) {
       // TypesList();
      print(response.statusCode);
      return jsonDecode(response.body);
    } else {
      print(
          '4e 5asser sa77bi mad5al======================================');
      return Future.error('Server Error');

    }
    }catch (err) {
      print('Server Error: $err');
    }
  }


  //Prof
  void AddProf (String nom,String prenom,String email, String tel,String Banque, String Compte) async {
  final response = await http.post(
  Uri.parse(addprof),
  headers: <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
  },
  body: jsonEncode(<String, dynamic>{
    "nom":nom,
    "prenom":prenom ,
    "email": email ,
    "tel": tel ,
    "Banque": Banque ,
    "Compte": Compte ,
  }),
  );
  if (response.statusCode == 201) {
    _prenom.clear();
    _nom.clear();
    _email.clear();
    _tel.clear();
    _banque.clear();
    _compte.clear();
  TypesList();
  } else {
  print("SomeThing Went Wrong");
  }
}

  Future<List> ProfList() async {
    // var regBody = {
    //   "userId":userId
    // };
    try {
      var response = await http.get(Uri.parse(GetProfs),
        headers: {"Content-Type": "application/json"},
        // body: jsonEncode(regBody)
      );
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        // List<Type> types = jsonList.map((json) => Type.fromJson(json)).toList();
        // return types;
        return jsonDecode(response.body);
        print('4e sla7 --------------------------------------------');
      } else {
        return Future.error('Server Error');
        print('4e 5asser sa77bi mad5al======================================');
      }
    } catch (e) {
      return Future.error(e);
    }
  }
  Future<List<Prof>>  Profs() async {
    // var regBody = {
    //   "userId":userId
    // };

    var response = await http.get(Uri.parse(GetProfs),
      headers: {"Content-Type":"application/json"},
      // body: jsonEncode(regBody)
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      items = jsonResponse;
      List<Prof> profs = [];

      for (var item in jsonResponse) {
        profs.add(
          Prof(
            id: item['_id'],
            nom: item['nom'],
            prenom: item['prenom'],
            email: item['email'],
            tel: item['tel'],
            Banque: item['Banque'],
            Compte: item['Compte'],
          ),
        );
      }

      print(profs);
      // setState(() {
      //
      // });
      return profs;


    } else {
      throw Exception('Server Error');
    }
  }

  Future<List<Map<String, dynamic>>?> Professeur(id) async {
    try {
      var response = await http.get(
        Uri.parse(GetProfesseur + "/$id"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        // print('4e sla7 --------------------------------------------');
        // print(response.body);
        var data = jsonDecode(response.body);
        return data != null ? [data] : null;
      } else {
        throw Exception('Server Error');
      }

    } catch (e) {
      throw Exception(e);
    }
  }
  Future<List> ProfCours(id) async {
    try {
      var response = await http.get(
        Uri.parse(GetProfCourses + "/$id"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        print('4e sla7 --------------------------------------------');
        // print(response.body);
        var data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Server Error');
      }

    } catch (e) {
      throw Exception(e);
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
      ProfList();
    }

  }

  void UpdateProf(String id, String nom,String prenom,String email, String tel,String Banque, String Compte) async {
    final response = await http.put(
      Uri.parse(updateProf + "/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "nom":nom,
        "prenom":prenom ,
        "email": email ,
        "tel": tel ,
        "Banque": Banque ,
        "Compte": Compte ,
      }),
    );
      if (response.statusCode == 201) {
        _prenom.clear();
        _nom.clear();
        _email.clear();
        _tel.clear();
        _banque.clear();
        _compte.clear();
        // Navigator.pop(context);
        ProfList();
      } else {
        print("Something Went Wrong");
      }
    }


    //Total Cours
  Future<num?> getTotal(String id, DateTime dateDeb, DateTime dateFin) async {
    try {
      final formattedDateDeb = DateFormat('yyyy/MM/dd').format(dateDeb);
      final formattedDateFin = DateFormat('yyyy/MM/dd').format(dateFin);
      final response = await http.get(Uri.parse('$GetTotal/$id?dateDeb=$formattedDateDeb&dateFin=$formattedDateFin'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final total = data['total'] ;
        print('Total: $total');
        return total;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('Server Error: $err');
    }
  }
  Future<num?> getTotals( DateTime dateDeb, DateTime dateFin) async {
    try {
      final formattedDateDeb = DateFormat('yyyy/MM/dd').format(dateDeb);
      final formattedDateFin = DateFormat('yyyy/MM/dd').format(dateFin);
      final response = await http.get(Uri.parse('$GetTotal?dateDeb=$formattedDateDeb&dateFin=$formattedDateFin'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final total = data['total'] ;
        print('Total: $total');
        return total;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (err) {
      print('Server Error: $err');
    }
  }



  Future<List> getCours(DateTime dateDeb, DateTime dateFin) async {

    final formattedDateDeb = DateFormat('yyyy/MM/dd').format(dateDeb);
    final formattedDateFin = DateFormat('yyyy/MM/dd').format(dateFin);
    final queryParams = '?dateDeb=$formattedDateDeb&dateFin=$formattedDateFin';
    final url = Uri.parse(CoursPeriode + '$queryParams');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;
      // final coursList = jsonData.map((item) => Cours.fromJson(item)).toList();
      print(jsonData);
      return jsonData;
    } else {
      throw Exception('Failed to fetch cours');
    }
  }

}
class Type {


  Type({
    required this.id,
    required this.name,
    required this.taux,
  });
  late final String id;
  late final String name;
  late final int taux;

  factory Type.fromJson(Map<String, dynamic> json){
    return Type(
      id: json['_id'],
      name: json['name'],
      taux: json['taux'],
    );
  }

}
