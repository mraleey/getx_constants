import 'package:flutter/material.dart';
import '../../../constants/fonts.dart';

class DatabaseRestore extends StatefulWidget {
  const DatabaseRestore({super.key});

  @override
  DatabaseRestoreState createState() => DatabaseRestoreState();
}

class DatabaseRestoreState extends State<DatabaseRestore> {
  String? dropDownValue;

  List<String> dropDownList = ['Test 1', 'Test 2', 'Test 3', 'Test 4', 'Test 5'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              'Restore Database',
              style: TextStyle(
                  fontSize: CustomFontSize.extraExtraLarge(context) * 1.5,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButton<String>(
                menuMaxHeight: 250,
                padding: const EdgeInsets.only(right: 20, left: 20),
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 30,
                borderRadius: BorderRadius.circular(20),
                hint: const Text('Select Database Link'),
                itemHeight: 60,
                underline: const SizedBox(),
                autofocus: true,
                dropdownColor: Colors.white,
                value: dropDownValue,
                isExpanded: true,
                items: dropDownItems(),
                onChanged: (value) {
                  setState(() {
                    dropDownValue = value;
                  });
                  _showDialog(value);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> dropDownItems() {
    return dropDownList.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  void _showDialog(String? value) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          // actionsPadding: EdgeInsets.all(5),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          title: const Text('Set Database'),
          content: Text('You selected Link: $value'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel' , style: TextStyle(color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Restore', style: TextStyle(color: Colors.green),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Suspend', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }
}
