import 'package:flutter/material.dart';

import '../../../DataLayer/Models/StoreModels/Store.dart';

class StoreTimingText extends StatelessWidget {
  const StoreTimingText({
    Key? key,
    required this.loadedStore,
  }) : super(key: key);

  final Store loadedStore;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          loadedStore.isOpen!
              ? Row(
                  children: <Widget>[
                    Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      " - Close at ",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      loadedStore.closingHour!.dateTimeFormated(),
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    Text(
                      "Closed",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      " - Opens tommorrow at ",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      loadedStore.openingHour!.dateTimeFormated(),
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
