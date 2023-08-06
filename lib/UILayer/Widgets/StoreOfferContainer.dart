import 'package:flutter/material.dart';

import '/DataLayer/Models/StoreModels/Offer.dart';

class StoreOfferContainer extends StatefulWidget {
  final List<Offer> offerList;
  final int index;

  StoreOfferContainer(this.offerList, this.index);

  @override
  _StoreOfferContainerState createState() => _StoreOfferContainerState();
}

class _StoreOfferContainerState extends State<StoreOfferContainer> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 5,
      shape: RoundedRectangleBorder(),
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(
              milliseconds: 300,
            ),
            height: _isExpanded ? 200 : 95,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("${widget.offerList[widget.index].description}"),
                AnimatedContainer(
                  duration: Duration(
                    milliseconds: 300,
                  ),
                  height: _isExpanded ? 90 : 0,
                  color: Colors.grey[100],
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("Min Amount",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Max Discount",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text("Offer code",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Divider(thickness: 5.0, color: Colors.grey[200]),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("${widget.offerList[widget.index].minAmount}"),
                            Text(
                                "${widget.offerList[widget.index].maxDiscount}"),
                            Text("${widget.offerList[widget.index].offerCode}"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  }))
        ],
      ),
    );
  }
}
