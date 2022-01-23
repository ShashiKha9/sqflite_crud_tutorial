

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_crud_tutorial/database/notes_database.dart';
import 'package:sqflite_crud_tutorial/models/note.dart';
import 'package:sqflite_crud_tutorial/screens/add_note.dart';
class HomeScreen extends StatefulWidget{
  HomeScreenState createState()=> HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
   List<Note> _noteList=[];
  final DateFormat _dateFormatter = DateFormat('MMM DD, YYYY');
@override
void initState(){
  getData();
  super.initState();

}
  Future<void> getData() async{

  _noteList= await NoteDatabase.instance.readNote();
  print(_noteList[0].title);


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=> AddNoteScreen(
            updateNoteList: getData,
          )));
        },
        child: Icon(Icons.add),
      ),
      body:
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Notes",style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,

                  ),),
                        Flexible(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: _noteList.length,
                              itemBuilder: (context, index) {
                                final Note note = _noteList[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(note.title!, style: TextStyle(
                                          color: Colors.black87),),
                                      subtitle: Text("${_dateFormatter.format(
                                          note.date!)}- ${note.priority}"),
                                      trailing: Checkbox(
                                        onChanged: (value) {
                                          note.status = value! ? 1 : 0;
                                          NoteDatabase.instance.updateNote(note);
                                          getData();
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context)=> HomeScreen()));
                                        },
                                        value: note.status == 1 ? true : false,
                                        activeColor: Theme
                                            .of(context)
                                            .primaryColor,

                                      ),
                                      onTap: () =>
                                          Navigator.push(
                                              context, CupertinoPageRoute(
                                              builder: (context) =>
                                                  AddNoteScreen(
                                                    updateNoteList: getData,
                                                    note: note,
                                                  ))),
                                    ),
                                    Divider(
                                      height: 5.0,
                                    )
                                  ],

                                );
                              }),
                        )
                    ],
            ),
        ),
    );
  }
}
