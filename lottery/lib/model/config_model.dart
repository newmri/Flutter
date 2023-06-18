class ConfigModel{
  int id;
  int value;

  ConfigModel({required this.id, required this.value});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id': id,
      'value': value,
    };
  }

}