import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';

import '/DataLayer/Models/StoreModels/RateList.dart';

class RateListContainer extends StatefulWidget {
  final List<RateListItem> rateListItem;
  final int index;

  RateListContainer(this.rateListItem, this.index);
  @override
  _RateListContainerState createState() => _RateListContainerState();
}

class _RateListContainerState extends State<RateListContainer> {
  @override
  Widget build(BuildContext context) {
    return GFAccordion(
      title: widget.rateListItem[widget.index].categoryName,
      contentChild: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                "Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "Price",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.rateListItem[widget.index].serviceName!,
              ),
              Text(
                widget.rateListItem[widget.index].serviceRate!.isFixed!
                    ? "\u{20B9} ${widget.rateListItem[widget.index].serviceRate?.fixed} (FIX)"
                    : "\u{20B9} ${widget.rateListItem[widget.index].serviceRate?.low} - \u{20B9} ${widget.rateListItem[widget.index].serviceRate?.high}",
              )
            ],
          ),
        ],
      ),
    );
  }
}
