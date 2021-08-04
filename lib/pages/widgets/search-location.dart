import 'package:flutter/material.dart';

typedef OnEditCompleteEvent = Future<void> Function(String location);

class SearchLocation extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final OnEditCompleteEvent callbackFn;
  SearchLocation(
      {Key? key,
      required this.focusNode,
      required this.textEditingController,
      required this.callbackFn})
      : super(key: key);

  void _onEditingComplete(OnEditCompleteEvent cb) async {
    await cb(textEditingController.text);
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: TextField(
        focusNode: focusNode,
        decoration: InputDecoration(
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          labelText: 'Enter a city name',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
        ),
        cursorColor: Colors.red,
        controller: textEditingController,
        onEditingComplete: () => _onEditingComplete(callbackFn),
      ),
    );
  }
}
