class Note{
  int? id;
  String? title;
  DateTime? date;
  String? priority;
  int? status;

  Note({
     this.date,
    this.title,
    this.id,
    this.status,
    this.priority
});
  Map<String,dynamic> toMap(){
    final map =Map<String,dynamic>();
    map['title']=title;
    map['date']=date!.toIso8601String();
    map['priority']=priority;
    map['status']=status;
    return map;


  }
  factory Note.fromMap(Map<String,dynamic> map)=>Note(
      id: map['id'],
    title: map['title'],
    status: map['status'],
    date:DateTime.parse(map['date']),
    priority: map['priority'],
  );
}