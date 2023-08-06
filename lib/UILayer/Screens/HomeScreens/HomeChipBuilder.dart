import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../BloCLayer/StoreBloc.dart';
import '../../../BloCLayer/StoreEvent.dart';

class HomeChipBuilder extends StatefulWidget {
  @override
  _HomeChipBuilderState createState() => _HomeChipBuilderState();
}

class _HomeChipBuilderState extends State<HomeChipBuilder> {
  var data = ['Price', 'By Kg', 'By Piece'];
  var selected = [];
  @override
  Widget build(BuildContext context) {
    StoreBloc storeBloc = BlocProvider.of<StoreBloc>(context);
    return Container(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.only(left: 10, top: 10),
          child: FilterChip(
            label: Text(
              data[index],
              style: GoogleFonts.openSans(
                fontSize: 13,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
                side: BorderSide(color: Colors.grey[400]!)),
            onSelected: (bool value) {
              if (selected.contains(index)) {
                selected.remove(index);
                storeBloc.mapEventToState(SortByName());
                print(selected.toString());
              } else {
                selected.add(index);
                if (index == 0) {
                  storeBloc.mapEventToState(SortByPrice());
                }
                print(selected.toString());
              }
              setState(() {});
            },
            selected: selected.contains(index),
            selectedColor: Colors.lightBlueAccent,
            labelStyle: TextStyle(
              color: Colors.black,
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
