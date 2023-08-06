import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

import '/BloCLayer/UserBloc.dart';
import '/DataLayer/Models/Other/Enums.dart';
import '/UILayer/Widgets/CurrentOrderCard.dart';
import '/UILayer/Widgets/noNetwork.dart';
import '../../../BloCLayer/OrderBloc.dart';
import '../../../BloCLayer/OrderEvent.dart';
import '../../../DataLayer/Models/OrderModels/Order.dart';
import '../../../const.dart';

class CurrentOrdersScreen extends StatefulWidget {
  // final Order order;
  // CurrentOrdersScreen({@required this.order});
  @override
  _CurrentOrdersScreenState createState() => _CurrentOrdersScreenState();
}

class _CurrentOrdersScreenState extends State<CurrentOrdersScreen>
    with AutomaticKeepAliveClientMixin {
  OrderBloc? _orderBloc;
  UserBloc? _userBloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _orderBloc = BlocProvider.of<OrderBloc>(context);
    _userBloc = BlocProvider.of<UserBloc>(context);
    _orderBloc!
        .mapEventToState(CurrentOrderFetch(userId: _userBloc!.getUser.uid!));

    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Container(
      color: Constants.bgColor,
      child: Center(
        child: connectionStatus == ConnectivityStatus.offline
            ? NoNetwork()
            : StreamBuilder<List<Order>>(
                initialData: _orderBloc!.getCurrentOrders,
                stream: _orderBloc!.currentOrderStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Order>> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.hasError) {
                      return Text("Error occured. please try again later");
                    } else if (snapshot.data!.length == 0) {
                      //receieved an empty list
                      return Text("You have placed no orders");
                    } else {
                      int _length = snapshot.data!.length;
                      print(_length);
                      // print(snapshot.data);
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: _length,
                              itemBuilder: (BuildContext context, index) {
                                return CurrentOrder(
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

  @override
  bool get wantKeepAlive => true;
}
