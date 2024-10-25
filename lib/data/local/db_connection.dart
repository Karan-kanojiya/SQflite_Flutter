import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class dbConnections {
  //singleton
  dbConnections._(); //privatization don't use the class

  static final  dbConnections getInstance = dbConnections._();
  // table note
  static final String TABLE_NOTE = "note";
  static final String COLUMN_NOTE_SNO = "s_nO";
  static final String COLUMN_NOTE_TITLE  = "title";
  static final String COLUMN_NOTE_DESC = "desc";
  Database? myDB;
  // datebase open
 Future<Database> getDb()async{
    myDB ??= await OpenDb();
    return myDB! ;
  /* if(myDB!=null){
     return myDB!;
   }else{
     myDB = await OpenDb();
     return myDB!;
   }*/
 }
 Future<Database> OpenDb() async{
 Directory appdir = await getApplicationDocumentsDirectory();
 String dbpath = join(appdir.path,"noteDB.db");
 return await openDatabase(dbpath,onCreate: (db , version){
   // create all your tabe here
   db.execute("Create table note$TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincrement,$COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC title" );
   // so many table are create

 },version: 1);
 
 }
 // all queries


  Future<bool> addNote({required String mtitle ,required String mdesc}) async{
   var db =  await getDb();
   try{
     await db.insert(TABLE_NOTE, {
       COLUMN_NOTE_TITLE : mtitle,
       COLUMN_NOTE_DESC : mdesc
     });
   }on Error{
     throw Error();
   }

   return true;

}

  Future<List<Map<String, dynamic>>>  getAllNote()async{
   var db = await getDb();
   // select * fromt note
   List<Map<String ,dynamic>> mData = await db.query(TABLE_NOTE,);
 return mData;


}

}
