import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/shape/gf_button_shape.dart';

import '/const.dart';
import '../../../DataLayer/Models/StoreModels/Store.dart';

class StoreGallery extends StatelessWidget {
  const StoreGallery({
    Key? key,
    required this.loadedStore,
  }) : super(key: key);

  final Store loadedStore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: loadedStore.myGallery![0],
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GFButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) =>
                            StoreGalleryTile(loadedStore: loadedStore)),
                  );
                },
                shape: GFButtonShape.pills,
                icon: Icon(
                  Icons.arrow_right,
                  color: Colors.white,
                ),
                text: "View Gallery   ",
                color: Colors.amber,
                textColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     height: MediaQuery.of(context).size.height * 0.4,
  //     padding: const EdgeInsets.only(bottom: 10),
  //     child: ClipRRect(
  //       child: PhotoViewGallery.builder(
  //         itemCount: loadedStore.myGallery.length,
  //         builder: (context, index) {
  //           return PhotoViewGalleryPageOptions(
  //             imageProvider:
  //                 CachedNetworkImageProvider("${loadedStore.myGallery[index]}"),
  //             minScale: PhotoViewComputedScale.contained * 0.8,
  //             maxScale: PhotoViewComputedScale.covered * 2,
  //           );
  //         },
  //         scrollPhysics: BouncingScrollPhysics(),
  //         backgroundDecoration: BoxDecoration(
  //           color: Colors.white,
  //         ),
  //         loadingBuilder: (context, imageChunk) {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }
}

class StoreGalleryTile extends StatelessWidget {
  const StoreGalleryTile({
    Key? key,
    required this.loadedStore,
  }) : super(key: key);

  final Store loadedStore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store Gallery',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: (3 / 2)),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: loadedStore.myGallery?.length != null
                  ? loadedStore.myGallery?.length
                  : 0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (context, _, __) => GalleryPreview(
                          imageUrl: loadedStore.myGallery![index],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(1),
                    ),
                    color: Color(
                            (math.Random().nextDouble() * 0xFFFFFF).toInt() <<
                                0)
                        .withOpacity(1.0),
                    child: Hero(
                      tag: loadedStore.myGallery![index],
                      child: FadeInImage.memoryNetwork(
                        imageScale: 1,
                        fit: BoxFit.cover,
                        image: loadedStore.myGallery![index],
                        placeholder: Constants.transparentImage,
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class GalleryPreview extends StatefulWidget {
  final String imageUrl;
  GalleryPreview({required this.imageUrl});
  @override
  _GalleryPreviewState createState() => _GalleryPreviewState();
}

class _GalleryPreviewState extends State<GalleryPreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Container(
            child: Hero(
              tag: widget.imageUrl,
              child: FadeInImage.memoryNetwork(
                imageScale: 1,
                image: widget.imageUrl,
                placeholder: Constants.transparentImage,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
