
class OutputForms {
  var id;
  var formno;
  var dataOutput;
  OutputForms(
      {required this.formno,
        required this.dataOutput,
        this.id});

  factory OutputForms.fromMap(Map<String, dynamic> json) => OutputForms(
    id: json['id'],
    formno: json['formno'],
    dataOutput: json['dataOutput'],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formno': formno,
      'dataOutput': dataOutput,
    };
  }
}
