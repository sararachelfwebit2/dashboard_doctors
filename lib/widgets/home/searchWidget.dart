import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.hintText,
  }) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.grey[800], fontSize: 14);
    final styleHint = TextStyle(color: Colors.grey[300], fontSize: 14);
    final style = widget.text.isEmpty ? styleHint : styleActive;
    final Size size = MediaQuery.of(context).size;

    return Container(
      height: 40,
      // width: size.width * 0.2,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 20,bottom: 10),
       padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(-5, -5),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
          textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search, color: style.color),
          // suffixIcon: widget.text.isNotEmpty
          //     ? GestureDetector(
          //   child: Icon(Icons.close, color: style.color),
          //   onTap: () {
          //     controller.clear();
          //     widget.onChanged('');
          //     FocusScope.of(context).requestFocus(FocusNode());
          //   },
          // )
          //     : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: widget.onChanged,
      ),
    );
  }
}
