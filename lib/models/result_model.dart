import 'package:cloud_firestore/cloud_firestore.dart';

class Result {
  final String? name;
  final double? latitude;
  final double? longitude;

  Result({this.name, this.latitude, this.longitude});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<Result> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          // ignore: cast_nullable_to_non_nullable
          snapshot.data() as Map<String, dynamic>;

      return Result(
        name: dataMap['name'] as String?,
        latitude: dataMap['latitude'] as double?,
        longitude: dataMap['longitude'] as double?,
      );
    }).toList();
  }
}
