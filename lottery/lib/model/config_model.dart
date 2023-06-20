class ConfigModel {
  int id;
  int value;

  ConfigModel({required this.id, required this.value});

  factory ConfigModel.fromMap(Map<String, dynamic> json) => ConfigModel(
        id: json['id'],
        value: json['value'],
      );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }
}
