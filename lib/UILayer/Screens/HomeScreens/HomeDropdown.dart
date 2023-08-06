// import 'package:flutter/material.dart';
// import 'package:generic_bloc_provider/generic_bloc_provider.dart';
// import 'package:pietycustomerapplication/BloCLayer/UserBloc.dart';
// import 'package:pietycustomerapplication/DataLayer/Models/adminModels/adminMetaData.dart';

// import '../../../BloCLayer/StoreBloc.dart';
// import '../../../BloCLayer/StoreEvent.dart';

// class HomeDropdown extends StatefulWidget {
//   @override
//   _HomeDropdownState createState() => _HomeDropdownState();
// }

// class _HomeDropdownState extends State<HomeDropdown> {
//   String dropdownValue = "Laundry";
//   @override
//   Widget build(BuildContext context) {
//     StoreBloc storeBloc = BlocProvider.of<StoreBloc>(context);
//     UserBloc userBloc = BlocProvider.of<UserBloc>(context);
//     storeBloc.mapEventToState(GetStoresOfType(
//         storeType: dropdownValue, currentPosition: userBloc.userPlace));
//     return StreamBuilder<List<StoreType>>(
//         initialData: storeBloc.storeTypes,
//         stream: storeBloc.storeTypeStream,
//         builder: (context, AsyncSnapshot<List<StoreType>> snapshot) {
//           if (snapshot.hasData) {
//             if (snapshot.hasError) {
//               return Text("Error");
//             } else {
//               storeBloc.selectedStoreStream.listen((store) {
//                 setState(() {
//                   dropdownValue = store;
//                 });
//               });
//               List<String> items = snapshot.data.map((e) => e.name);
//               return Container(
//                 padding: const EdgeInsets.only(left: 10, right: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(5),
//                   border: Border.all(color: Colors.grey[400]),
//                 ),
//                 child: DropdownButton<String>(
//                   isDense: true,
//                   value: dropdownValue,
//                   onChanged: (String val) {
//                     print(userBloc.userPlace.locality);
//                     storeBloc.mapEventToState(GetStoresOfType(
//                         storeType: val, currentPosition: userBloc.userPlace));
//                     storeBloc
//                         .mapEventToState(SelectedStore(selectedStore: val));
//                     setState(() {
//                       dropdownValue = val;
//                     });
//                   },
//                   items: items.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                 ),
//               );
//             }
//           } else {
//             return Text("Loading");
//           }
//         });
//   }
// }
