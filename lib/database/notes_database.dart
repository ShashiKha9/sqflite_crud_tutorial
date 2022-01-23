
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_crud_tutorial/models/note.dart';


class NoteDatabase{




  static final NoteDatabase instance = NoteDatabase._instance();

  static  Database? _db = null;

  NoteDatabase._instance();

  String noteTable ='note_table';
  String colId='id';
  String colTittle='title';
  String colDate ='date';
  String colPriority='priority';
  String colStatus='status';

  Future<Database?> get db async{
    if(_db != null) {
      return _db;
    }
      _db = await _initDB();
    return _db;

  }

 Future<Database>_initDB() async {
   final dpPath = await  getDatabasesPath();
   final path = join(dpPath,'notes.db');
   return await openDatabase(path,version: 1,onCreate: _createDb);

  }

 void  _createDb(Database _db,int version) async {
   await  _db.execute(
     'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colTittle Text,$colDate Text, $colPriority Text,$colStatus Integer)'
   );
  }
  Future<int> createNote(Note note) async {
    final db = await instance.db;
    return await db!.insert(noteTable,note.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int> updateNote(Note note) async{
    final db = await instance.db;
    return await db!.update(noteTable, note.toMap(),
      where: '$colId=?',
      whereArgs: [note.id]
    );
  }
  Future<int> deleteNote(int id) async{
    final db = await instance.db;
    return await db!.delete(noteTable,
        where: '$colId=?',
        whereArgs: [id]
    );
  }
  Future <List<Note>> readNote()async{
    final List<Note> noteList=[];
    final db = await instance.db;
    List<Map<String,dynamic>> update =await db!.query(noteTable);
    return update.map((e) => Note.fromMap(e)).toList();
  }

}