class MatiereType {
  String? id;
  String? name;
  int? taux;

  MatiereType({this.id, this.name, this.taux});
}
class Matiere {
  String? id;
  String? name;
  int? coef;
  String? taux;

  Matiere({this.id, this.name,this.coef, this.taux});
}
class Prof {
  String? id;
  String? nom;
  String? prenom;
  String? email;
  int? tel;
  String? Banque;
  String? Compte;

  Prof({this.id, this.nom,this.prenom,this.email,this.tel,this.Banque, this.Compte});
}
class Courses {
  String? id;
  Prof? prof;
  Matiere? matiere;
  DateTime? date;
  DateTime? deb;
  DateTime? fin;
  num? CM;
  num? TP;
  num? TD;
  num? total;

  Courses({this.id, this.prof,this.matiere, this.date,this.deb,this.fin,this.CM,this.TP,this.TD,this.total});
}