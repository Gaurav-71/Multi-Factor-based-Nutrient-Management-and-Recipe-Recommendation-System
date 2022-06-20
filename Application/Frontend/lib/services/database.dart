import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference

  final db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> downloadData(uid) {
    return db.collection("NutritionData").doc(uid).snapshots();
    // collection.snapshots().listen(
    //       (event) => {print("current data: ${event.data()}")},
    //       onError: (error) => print("Listen failed: $error"),
    //     );
  }

  uploadData(uid, data) {
    db.collection("NutritionData").doc(uid).set(data);
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
