import 'package:flutter/material.dart';

import 'dbdata.dart';




class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _items = [];
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController UpdateController = TextEditingController();
  final TextEditingController descUpdateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final items = await _dbHelper.fetchItems();
    setState(() {
      _items = items;
    });
  }

  void _insertItem() async {
    if (_controller.text.isNotEmpty && _descController.text.isNotEmpty) {
      await _dbHelper.insertItem(_controller.text ,_descController.text);
      _controller.clear();
      _descController.clear();
      _loadItems();
    }
  }

  void _deleteItem(int id) async {
    await _dbHelper.deleteItem(id);
    _loadItems();
  }

  void _updateItem(int id, String newName,String desc) async {
    await _dbHelper.updateItem(id, newName,desc);
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SQFlite Demo'),
      actions: [
        IconButton(onPressed: (){
          showDialog(context: context, builder: (builder)=>AlertDialog(
            title: Column(
              children: [
                TextFormField(
                  controller: _controller,
                ), TextFormField(
                  controller: _descController,
                ),
                ElevatedButton(onPressed:(){

                  _insertItem();
                  Navigator.pop(context);
                } , child: Text('Add Item')),


              ],
            ),
          ));

        }, icon: Icon(Icons.add,color: Colors.black,))],
      ),

      body: Column(
        children: [
        //  TextField(controller: _controller),
        //  ElevatedButton(onPressed: _insertItem, child: Text('Add Item')),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  leading: Text(item['id'].toString()),
                  title: Text(item['name']),
                  subtitle: Text(item['desc']??""),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          alertdialog(item['id']);

                         // _updateItem(item['id'], 'Updated Name');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteItem(item['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  alertdialog(id){
   showDialog(context: context,
       builder: (contex){
     return AlertDialog(
       title: Column(
         mainAxisSize: MainAxisSize.min,
         children: [
           TextFormField(
             controller: UpdateController,
           ),
           SizedBox(height: 10,),
           Container(
             height: 40,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(15),
               border: Border.fromBorderSide(BorderSide(color: Colors.amberAccent))
             ),
             child: TextFormField(
               textAlign: TextAlign.left,
               decoration: InputDecoration(
                 border: InputBorder.none,
               ),
               controller: descUpdateController,
             ),
           ),
           SizedBox(height: 10,),
           OutlinedButton(onPressed: (){
             _updateItem(id, UpdateController.text,descUpdateController.text);
             Navigator.pop(context);
           }, child: Text("Update"))
         ],
       ),
     );
       });
  }
}
