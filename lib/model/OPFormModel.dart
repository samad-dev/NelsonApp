
class OutputForms {
  var formname;
  var dataOutput;
  OutputForms(
      {
        required this.dataOutput,
        required this.formname});

  factory OutputForms.fromMap(Map<String, dynamic> json) => OutputForms(
    formname: json['formname'],
    dataOutput: json['dataOutput'],
  );
  Map<String, dynamic> toMap() {
    return {
      'formname': formname,
      'dataOutput': dataOutput,
    };
  }
}
