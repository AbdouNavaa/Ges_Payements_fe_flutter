import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Methodes.dart';
import '../config.dart';

class ProfCours extends StatefulWidget {
  // final token;
  const ProfCours({Key? key, this.ProfId, required this.ProfName}) : super(key: key);
  final String? ProfId;
  final String ProfName;

  @override
  State<ProfCours> createState() => _ProfCoursState();
}

class _ProfCoursState extends State<ProfCours> {

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
  List? items;
  late MyNewClass _myNewClass = MyNewClass();


  @override
  void initState() {
    super.initState();
    _myNewClass.ProfCours(widget.ProfId).then((data) {
      setState(() {
        items = data; // Assigner la liste renvoyée par Professeur à items
      });
    }).catchError((error) {
      print('Erreur: $error');
    });
  }

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

  List? filteredItems;

  @override
  Widget build(BuildContext context) {

    if (items != null) {
      DateTime? startDate;
      DateTime? endDate;
      if (startDateController.text.isNotEmpty) {
        startDate = DateFormat('yyyy/MM/dd').parse(startDateController.text);
      }
      if (endDateController.text.isNotEmpty) {
        endDate = DateFormat('yyyy/MM/dd').parse(endDateController.text);
      }

      filteredItems = items!.where((item) {
        final itemDate = DateTime.parse(item['date']);
        return (startDate == null || itemDate.isAtSameMomentAs(startDate) || itemDate.isAfter(startDate)) &&
            (endDate == null || itemDate.isAtSameMomentAs(endDate) || itemDate.isBefore(endDate));
      }).toList();
    } else {
      filteredItems = null;
    }

    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    ' ${widget.ProfName} Cours: ${items?.length} ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
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
                    String id = widget.ProfId ?? '';
                    DateTime dateDeb = DateFormat('yyyy/MM/dd').parse(startDateController.text);
                    DateTime dateFin = DateFormat('yyyy/MM/dd').parse(endDateController.text);
                    _myNewClass.getTotal(id, dateDeb, dateFin).then((total) {
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: filteredItems == null
                  ? Text("Items is null")
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredItems!.length,
                itemBuilder: (context, int index) {
                  // Tri des éléments par ordre croissant de date
                  filteredItems!.sort((a, b) => a['date'].compareTo(b['date']));

                  return Container(
                    width: 250,
                    margin: EdgeInsets.all(20),
                    // margin: EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Colors.lightGreen,
                          width: 0,
                          style: BorderStyle.solid,
                        ),
                      ),
                      elevation: 20,
                      child: InkWell(
                        onTap: () {
                          // handle onTap
                        },
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 50,),
                              Text(
                                'Prof: ${filteredItems![index]['prof']['nom']}',
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
                                // '${items![index]['date']}'.toDateString(),
                                '${DateFormat('yyyy/MM/dd').format(DateTime.parse(items![index]['date']))}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                '${DateFormat('HH:mm').format(DateTime.parse(items![index]['Deb']))} to ${DateFormat('HH:mm').format(DateTime.parse(items![index]['Fin']))}',
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
                                '${items![index]['total'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
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
        ],
      ),

      floatingActionButton: Container(margin:EdgeInsets.only(left: 220),height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,  elevation: 20,shadowColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: (){

            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios,size: 30,color: Colors.green,),
              SizedBox(width: 15,),
              Text('Back', style: TextStyle(fontSize: 17,fontStyle: FontStyle.italic,color: Colors.green),)
            ],
          ),
          // tooltip: 'Add Prof',
        ),
      ),

    );
  }


}

