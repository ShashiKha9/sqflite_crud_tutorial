import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_crud_tutorial/database/notes_database.dart';
import 'package:sqflite_crud_tutorial/models/note.dart';
import 'package:sqflite_crud_tutorial/screens/home_screen.dart';
class AddNoteScreen extends StatefulWidget{
  final Note? note;
  final Function? updateNoteList;

   AddNoteScreen({Key? key,this.note,this.updateNoteList}) : super(key: key);

  AddNoteScreenState createState()=> AddNoteScreenState();

}

class AddNoteScreenState extends State<AddNoteScreen> {
  final _formkey = GlobalKey<FormState>();
  final DateFormat  _dateformat = DateFormat('MMM dd,yyyy');
  DateTime _date = DateTime.now();
  final List<String> _priorities = ['Low' ,'Medium','High'];
  String _priority ='Low';
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  String _title='';
  String btnText ="Add Note";
  String titleText ="Add Note";

  @override
  void initState(){
    super.initState();
    Note note= Note(title: _title,date:_date ,priority: _priority);
    if(widget.note != null){

      _title= widget.note!.title!;
      _date= widget.note!.date!;
      _priority= widget.note!.priority!;

      setState(() {
        btnText= "Update Note";
        titleText= "Update Note";
      });

    }
    else{
      setState(() {
        btnText= "Add Note";
        titleText= "Add Note";

      });
    }

    }


  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(context: context,
        initialDate: _date, firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(date != null && date != _date){
      setState(() {
        _date=date;
      });
      dateController.text=_dateformat.format(date);

    }
  }

  _submit(){
    if(_formkey.currentState!.validate()){
      _formkey.currentState!.save();
Note note= Note(title: _title,date:_date ,priority: _priority);
      if(widget.note == null){
        note.status=0;
        NoteDatabase.instance.createNote(note);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> HomeScreen()));
      }
      else{
        note.id= widget.note!.id;
        note.status= widget.note!.status;

        NoteDatabase.instance.updateNote(note);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context)=> HomeScreen()));
      }
      widget.updateNoteList!();
    }
  }
  _delete(){
    NoteDatabase.instance.deleteNote(widget.note!.id!);
    Navigator.pop(context);
  }
  @override
  void dipose(){
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: GestureDetector(
  onTap: ()=> FocusScope.of(context).unfocus(),
  child: SingleChildScrollView(
    child: Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText,style: TextStyle(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),),
          Form(
            key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText:"title",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      validator: (input){
                        if(input!.trim().isEmpty){
                       return   "Please enter anote title";
                        }
                      },
                      onSaved: (input)=> _title = input!,
                      initialValue: _title,
                    ),
                  ),
                  TextFormField(
                    onTap: ()=> _handleDatePicker(),
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                        labelText: "Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)
                        )
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: DropdownButtonFormField(
                      isDense: true,
                      items: _priorities.map((String priority) {
                        return DropdownMenuItem(
                          value: priority,
                            child: Text(priority,style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black87
                            ),));

                      }).toList(),
                      style: TextStyle(
                        fontSize: 18.0
                      ),
                      decoration: InputDecoration(
                        labelText: "Priority",
                        labelStyle: TextStyle(fontSize: 18.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                        )
                      ),
                      validator: (input)=> _priority == null ? 'please select a priority level': null,

                      onChanged: (value){
                        setState(() {
                          _priority= value.toString();
                        });

                      },
                      value: _priority,
                    ),

                  ),
                  Container(
                    height: 60.0,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor
                        )

                      ),
                        onPressed: _submit,
                        child: Text(btnText,
                          style: TextStyle(fontSize: 20.0),)),


                  ),
                widget != null ? Container(
                    height: 60.0,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 60.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).primaryColor
                            )
                        ),
                        onPressed:_delete,
                        child: Text("Delete",
                          style: TextStyle(fontSize: 20.0),)),
                  ):SizedBox.shrink()
                ],
              ))
        ],
      ),
    ),
  ),
),
    );
  }
}
