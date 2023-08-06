import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class StoreEvent extends Equatable {
  const StoreEvent();
  @override
  List<Object> get props => [];
}

class GetStoresOfType extends StoreEvent {
  final String storeType;
  final Placemark currentPosition;
  GetStoresOfType({required this.storeType, required this.currentPosition});
  @override
  List<Object> get props => [storeType, currentPosition];
}

class GetAllStore extends StoreEvent {}

class FetchLocalDB extends StoreEvent {}

class GetFeatureOfferList extends StoreEvent {}

class InitialData extends StoreEvent {
  final Placemark currentPosition;
  InitialData({required this.currentPosition});
  @override
  List<Object> get props => [currentPosition];
}

class GetStoreReview extends StoreEvent {
  final String storeId;
  GetStoreReview({required this.storeId});
  @override
  List<Object> get props => [storeId];
}

class GetStoreOffer extends StoreEvent {
  final String storeId;
  GetStoreOffer({required this.storeId});
  @override
  List<Object> get props => [storeId];
}

class GetSingleStore extends StoreEvent {
  final String storeID;
  GetSingleStore({required this.storeID});
  @override
  List<Object> get props => [storeID];
}

class FetchRateList extends StoreEvent {
  final String storeID;
  FetchRateList({required this.storeID});
  @override
  List<Object> get props => [storeID];
}

class GetStoreType extends StoreEvent {}

class SortByPrice extends StoreEvent {}

class SortByName extends StoreEvent {}

class GetRateListOfType extends StoreEvent {
  final String storeID;
  final String rateListType;
  GetRateListOfType({required this.rateListType, required this.storeID});
  @override
  List<Object> get props => [rateListType, storeID];
}

class FilterBasedStore extends StoreEvent {
  final bool isRatingFilter;
  final String? searchStoreName;
  final double? rating;
  final String? categoryStore;

  FilterBasedStore({ this.searchStoreName, required this.isRatingFilter,  this.rating, this.categoryStore});
}

// class GetCategoryListOfStore extends StoreEvent {
//   final String storeID;
//   GetCategoryListOfStore({@required this.storeID});
//   @override
//   List<Object> get props => [storeID];
// }

class SelectedStore extends StoreEvent {
  final String? selectedStore;
  final bool isFeatured;
  final String? storeName;
  SelectedStore({ this.selectedStore, required this.isFeatured, this.storeName});
  @override
  List<Object> get props => [selectedStore!];
}

class SearchBasedStore extends StoreEvent {
  final String serviceName;
  SearchBasedStore({required this.serviceName});
}
