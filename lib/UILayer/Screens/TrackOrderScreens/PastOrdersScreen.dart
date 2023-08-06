import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/UILayer/Widgets/PastOrderCardView.dart';
import '/UILayer/Widgets/noNetwork.dart';
import '../../../BloCLayer/OrderBloc.dart';
import '../../../BloCLayer/OrderEvent.dart';
import '../../../DataLayer/Models/OrderModels/Order.dart';
import '../../../const.dart';

class PastOrdersScreen extends StatefulWidget {
  // final Order order;
  // PastOrdersScreen({@required this.order});
  @override
  _PastOrdersScreenState createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  OrderBloc? _orderBloc;
  UserBloc? _userBloc;

  @override
  Widget build(BuildContext context) {
    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _orderBloc!
        .mapEventToState(PastOrdersFetch(userId: _userBloc!.getUser.uid!));
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Container(
      color: Constants.bgColor,
      child: Center(
        child: connectionStatus == ConnectivityStatus.offline
            ? NoNetwork()
            : StreamBuilder<List<Order>>(
                initialData: _orderBloc!.getPastOrders,
                stream: _orderBloc!.pastOrderListStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Text("Error occured. please try again later");
                    } else if (snapshot.data!.length == 0) {
                      //receieved an empty list
                      return Text("No Past orders");
                    } else {
                      int _length = snapshot.data!.length;
                      print(_length);
                      // print(snapshot.data);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              // CupertinoButton.filled(
                              //   onPressed: () {
                              //     _orderBloc.orderEventSink.add(
                              //       PastOrdersFetch(userId: "AAA123456"),
                              //     );
                              //   },
                              //   child: Text(
                              //     "Show all",
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.w600,
                              //       fontFamily: "OpenSans",
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _length,
                              itemBuilder: (BuildContext context, index) {
                                return PastOrderCardView(
                                  order: snapshot.data![index],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
      ),
    );
  }
}
