import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import '/BloCLayer/UserBloc.dart';
import '/BloCLayer/UserEvent.dart';
import '/DataLayer/Models/Other/EnumToString.dart';
import '/DataLayer/Models/Other/StringToEnum.dart';
import '/DataLayer/Models/UserModels/User.dart';
import '/DataLayer/Models/UserModels/UserAddress.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UserBloc? _userBloc;
  final _addressForm = GlobalKey<FormState>();
  String? _addressType;
  TextEditingController _name = TextEditingController();
  TextEditingController _houseNo = TextEditingController();
  TextEditingController _landmark = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _locality = TextEditingController();
  TextEditingController _state = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  String? name, houseNo, landmark, city, locality, state, postalCode;
  @override
  Widget build(BuildContext context) {
    _userBloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.blue,
        elevation: 50.0,
      ),
      body: StreamBuilder<User2>(
          initialData: _userBloc!.getUser,
          stream: _userBloc!.getUserStream,
          builder: (context, AsyncSnapshot<User2> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.hasError) {
                return Text("Error");
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 20.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 50),
                      snapshot.data!.name != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 40,
                                      child: Text(
                                        snapshot.data!.name!.isNotEmpty
                                            ? snapshot.data!.name!.substring(0, 1)
                                            : "U",
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  snapshot.data!.name!.isNotEmpty
                                      ? snapshot.data!.name!
                                      : "User",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Phone Number",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            snapshot.data!.phoneNumbers![0].number!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Address",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      Divider(
                        thickness: 1.0,
                      ),
                      SizedBox(height: 20),
                      StreamBuilder<dynamic>(   // List<UserAddress> is replaced by dynamic while making runnable
                        initialData: _userBloc!.getUserAllAddress,
                        stream: _userBloc!.allAddressStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.hasError) {
                              return Text("Something went wrong");
                            } else {
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      primary: false,
                                      physics: ClampingScrollPhysics(),
                                      // reverse: true,
                                      separatorBuilder: (context, count) {
                                        return SizedBox(width: 5);
                                      },
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, count) {
                                        // print(snapshot.data);
                                        return Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                          elevation: 2,
                                          margin: const EdgeInsets.all(5.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: InkWell(
                                              splashColor: Colors.amberAccent,
                                              onTap: () {},
                                              child: Container(
                                                color: Colors.white,
                                                width: 200.0,
                                                height: 200.0,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GridTile(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "${snapshot.data![count].profileAddress()}",
                                                        style: TextStyle(
                                                          // fontSize: 18,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    footer: GridTileBar(
                                                      backgroundColor:
                                                          Colors.amber,
                                                      trailing: IconButton(
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20.0)),
                                                                  child:
                                                                      Container(
                                                                    // height: 400,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          12.0),
                                                                      child:
                                                                          Form(
                                                                        key:
                                                                            _addressForm,
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Text("${Enum2String.getAddressType(snapshot.data![count].addressType)} Address",
                                                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                                                            TextFormField(
                                                                              initialValue: snapshot.data![count].name,
                                                                              onChanged: (val) {
                                                                                name = val.trim();
                                                                              },
                                                                              decoration: InputDecoration(labelText: "Name"),
                                                                              validator: (val) {
                                                                                if (val!.isEmpty) {
                                                                                  return "";
                                                                                } else {
                                                                                  return null;
                                                                                }
                                                                              },
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    initialValue: snapshot.data![count].houseNo,
                                                                                    onChanged: (val) {
                                                                                      houseNo = val.trim();
                                                                                    },
                                                                                    decoration: InputDecoration(labelText: "House No"),
                                                                                    validator: (val) {
                                                                                      if (val!.isEmpty) {
                                                                                        return "";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    onChanged: (val) {
                                                                                      landmark = val.trim();
                                                                                    },
                                                                                    initialValue: snapshot.data![count].landmark,
                                                                                    decoration: InputDecoration(labelText: "Landmark"),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    onChanged: (val) {
                                                                                      locality = val.trim();
                                                                                    },
                                                                                    initialValue: snapshot.data![count].locality,
                                                                                    decoration: InputDecoration(labelText: "Locality"),
                                                                                    validator: (val) {
                                                                                      if (val!.isEmpty) {
                                                                                        return "";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    onChanged: (val) {
                                                                                      city = val.trim();
                                                                                    },
                                                                                    initialValue: snapshot.data![count].city,
                                                                                    decoration: InputDecoration(labelText: "City"),
                                                                                    validator: (val) {
                                                                                      if (val!.isEmpty) {
                                                                                        return "";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    onChanged: (val) {
                                                                                      state = val.trim();
                                                                                    },
                                                                                    initialValue: snapshot.data![count].state,
                                                                                    decoration: InputDecoration(labelText: "State"),
                                                                                    validator: (val) {
                                                                                      if (val!.isEmpty) {
                                                                                        return "";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                Expanded(
                                                                                  child: TextFormField(
                                                                                    onChanged: (val) {
                                                                                      postalCode = val.trim();
                                                                                    },
                                                                                    initialValue: snapshot.data![count].postalCode,
                                                                                    decoration: InputDecoration(labelText: "Postal Code"),
                                                                                    keyboardType: TextInputType.number,
                                                                                    validator: (val) {
                                                                                      if (val!.isEmpty) {
                                                                                        return "";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                GFButton(
                                                                                  onPressed: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  text: "Close",
                                                                                  shape: GFButtonShape.standard,
                                                                                ),
                                                                                SizedBox(width: 5),
                                                                                GFButton(
                                                                                  onPressed: () {
                                                                                    if (_addressForm.currentState!.validate()) {
                                                                                      UserAddress _newAddres = UserAddress(
                                                                                        houseNo: houseNo ?? snapshot.data![count].houseNo,
                                                                                        landmark: landmark ?? snapshot.data![count].landmark,
                                                                                        locality: locality ?? snapshot.data![count].locality,
                                                                                        name: name ?? snapshot.data![count].name,
                                                                                        postalCode: postalCode ?? snapshot.data![count].postalCode,
                                                                                        addressType: snapshot.data![count].addressType,
                                                                                        city: city ?? snapshot.data![count].city,
                                                                                        state: state ?? snapshot.data![count].state,
                                                                                      );
                                                                                      // print("User edited value:: " + snapshot.data[count].toString());
                                                                                      _userBloc!.mapEventToState(
                                                                                        UpdateAddress(
                                                                                          deleteAddress: snapshot.data![count],
                                                                                          address: _newAddres,
                                                                                        ),
                                                                                      );
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                  text: "Save",
                                                                                  shape: GFButtonShape.standard,
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              });
                                                        },
                                                      ),
                                                      title: Text(
                                                        "${Enum2String.getAddressType(snapshot.data![count].addressType)}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          // fontSize: 18,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  GFButton(
                                    onPressed: snapshot.data!.length >= 3
                                        ? () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Can't Add More than 3 Address");
                                          }
                                        : () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      child: Container(
                                                        // height: 400,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Form(
                                                            key: _addressForm,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                        "Address Type: "),
                                                                    DropdownButton(
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              "Home",
                                                                          child:
                                                                              Text("Home"),
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          value:
                                                                              "Work",
                                                                          child:
                                                                              Text("Work"),
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          _addressType,
                                                                      onChanged:
                                                                          (val) {
                                                                        _addressType =
                                                                            val;
                                                                        setState(
                                                                            () {});
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _name,
                                                                  decoration: InputDecoration(
                                                                      labelText:
                                                                          "Name"),
                                                                  validator:
                                                                      (val) {
                                                                    if (val
                                                                        !.isEmpty) {
                                                                      return "";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _houseNo,
                                                                        decoration:
                                                                            InputDecoration(labelText: "House No"),
                                                                        validator:
                                                                            (val) {
                                                                          if (val
                                                                              !.isEmpty) {
                                                                            return "";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _landmark,
                                                                        decoration:
                                                                            InputDecoration(labelText: "Landmark"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _locality,
                                                                        decoration:
                                                                            InputDecoration(labelText: "Locality"),
                                                                        validator:
                                                                            (val) {
                                                                          if (val
                                                                              !.isEmpty) {
                                                                            return "";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _city,
                                                                        decoration:
                                                                            InputDecoration(labelText: "City"),
                                                                        validator:
                                                                            (val) {
                                                                          if (val
                                                                              !.isEmpty) {
                                                                            return "";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _state,
                                                                        decoration:
                                                                            InputDecoration(labelText: "State"),
                                                                        validator:
                                                                            (val) {
                                                                          if (val
                                                                              !.isEmpty) {
                                                                            return "";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Expanded(
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            _postalCode,
                                                                        decoration:
                                                                            InputDecoration(labelText: "Postal Code"),
                                                                        keyboardType:
                                                                            TextInputType.number,
                                                                        validator:
                                                                            (val) {
                                                                          if (val
                                                                              !.isEmpty) {
                                                                            return "";
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    GFButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      text:
                                                                          "Close",
                                                                      shape: GFButtonShape
                                                                          .standard,
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    GFButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (_addressType !=
                                                                            null) {
                                                                          if (_addressForm
                                                                              .currentState
                                                                              !.validate()) {
                                                                            UserAddress
                                                                                _newAddres =
                                                                                UserAddress(
                                                                              houseNo: _houseNo.text,
                                                                              landmark: _landmark.text,
                                                                              locality: _locality.text,
                                                                              name: _name.text,
                                                                              postalCode: _postalCode.text,
                                                                              addressType: String2Enum.getAddressType(_addressType!),
                                                                              city: _city.text,
                                                                              state: _state.text,
                                                                            );
                                                                            // print("User edited value:: " + snapshot.data[count].toString());
                                                                            _userBloc!.mapEventToState(
                                                                              AddAddress(
                                                                                newAddress: _newAddres,
                                                                              ),
                                                                            );
                                                                            Navigator.pop(context);
                                                                          }
                                                                        } else {
                                                                          Fluttertoast.showToast(
                                                                              msg: "Please Select Address Type");
                                                                        }
                                                                      },
                                                                      text:
                                                                          "Save",
                                                                      shape: GFButtonShape
                                                                          .standard,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                                });
                                          },
                                    child: Text(
                                      "Add Address",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    color: Colors.amber,
                                    shape: GFButtonShape.standard,
                                  ),
                                ],
                              );
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Text("Loading");
            }
          }),
    );
  }
}
