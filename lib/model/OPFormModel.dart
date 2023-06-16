
class OutputForms {
  var formname;
  var formId;
  var dataOutput;
  OutputForms(
      {
        required this.dataOutput,
        required this.formId,
        required this.formname
      });

  factory OutputForms.fromMap(Map<String, dynamic> json) => OutputForms(
    formname: json['formname'],
    formId: json['formId'],
    dataOutput: json['dataOutput'],
  );
  Map<String, dynamic> toMap() {
    return {
      'formname': formname,
      'formId': formId,
      'dataOutput': dataOutput,
    };
  }

}
