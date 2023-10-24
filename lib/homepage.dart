import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> notes = [];
  TextEditingController noteInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  void saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('notes', notes);
  }

  void addNote() {
    String noteText = noteInputController.text.trim();
    if (noteText.isNotEmpty) {
      setState(() {
        notes.add(noteText);
      });
      saveNotes();
      noteInputController.text = '';
    }
  }

  void deleteNoteAt(int index) {
    setState(() {
      notes.removeAt(index);
    });
    saveNotes();
  }

  void editNoteAt(int index) {
    String updatedNoteText = notes[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController editController =
            TextEditingController(text: updatedNoteText);
        return AlertDialog(
          title: Text('Edit your note '),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: 'Write your note... '),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  notes[index] = editController.text;
                });
                saveNotes();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: noteInputController,
              decoration: InputDecoration(hintText: ' Write your note '),
            ),
          ),
          ElevatedButton(
            onPressed: addNote,
            child: Text('Add'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          editNoteAt(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteNoteAt(index);
                        },
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
}