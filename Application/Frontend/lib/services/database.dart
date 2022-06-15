import 'package:cloud_firestore/cloud_firestore.dart';

class DatabseService {
  final String uid;
  DatabseService({required this.uid});
  // collection reference
  final CollectionReference nutritionDataCollection =
      FirebaseFirestore.instance.collection("NutritionData");

  Stream<QuerySnapshot> get nutritionData {
    return nutritionDataCollection.snapshots();
  }

  // Future getData() async {
  //   final docRef = nutritionData.doc(uid);
  //   docRef.get().then(
  //     (DocumentSnapshot doc) {
  //       if (doc.exists) {
  //         final data = doc.data() as Map<String, dynamic>;
  //         return data;
  //       } else {
  //         return null;
  //       }
  //     },
  //     onError: (e) {
  //       return "Error getting document: $e";
  //     },
  //   );
  // }
}
