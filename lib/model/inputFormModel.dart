
class InputForms {
  var id;
  var formId;
  var formName;
  var apiResp;
  InputForms(
      {required this.formName,
        required this.apiResp,
        required this.formId,
        this.id});

  factory InputForms.fromMap(Map<String, dynamic> json) => InputForms(
    id: json['id'],
    formName: json['formName'],
    formId: json['formId'],
    apiResp: json['apiResp'],
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'formId': formId,
      'formName': formName,
      'apiResp': apiResp,
    };
  }
}
