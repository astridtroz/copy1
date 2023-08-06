import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';

import '/BloCLayer/AdminBloc.dart';
import '/DataLayer/Models/adminModels/adminMetaData.dart';

class HomeCustomCarousel extends StatefulWidget {
  // final List<String> dashboardImage;
  // HomeCustomCarousel({
  //   @required this.dashboardImage,
  // });
  @override
  _HomeCustomCarouselState createState() => _HomeCustomCarouselState();
}

class _HomeCustomCarouselState extends State<HomeCustomCarousel> {
  @override
  Widget build(BuildContext context) {
    AdminBloc adminBloc = BlocProvider.of<AdminBloc>(context);
    adminBloc.fetchMetaData();

    return StreamBuilder<AdminMetaData>(
        stream: adminBloc.adminMetaDataStream,
        initialData: adminBloc.getAdminMetaData,
        builder: (context, snapshot) {
          return GFCarousel(
            items: List.generate(
                snapshot.data!.dashboradImage == null
                    ? 0
                    : snapshot.data!.dashboradImage!.length, (count) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    print("Carousel Page $count is Tapped.");
                  },
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Colors.grey,
                      image: DecorationImage(
                          image: NetworkImage(adminBloc
                                  .getAdminMetaData.dashboradImage![count] ??
                              ""),
                          fit: BoxFit.cover),
                      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey)],
                    ),
                  ),
                ),
              );
            }),
            onPageChanged: (index) {
              //print(index);
              setState(() {});
            },
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            enlargeMainPage: false,
            hasPagination: true,
            viewportFraction: 0.9,
          );
        });
  }
}
