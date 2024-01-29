import 'package:cloud_firestore/cloud_firestore.dart';

class FeedService {
  final CollectionReference _feedCollection =
      FirebaseFirestore.instance.collection('feed');

  Future<List<String>> getCouponList() async {
    try {
      final doc = await _feedCollection.doc("FE8e2ExMX3QiEUcKn3bg").get();
      if (doc.exists) {
        // Explicitly cast to List<String>
        List<String> couponList =
            (doc.data() as Map<String, dynamic>)['coupons'].cast<String>();
        print('couponList: ${couponList}');
        return couponList;
      } else {
        print('Collection not found');
        return [];
      }
    } catch (e) {
      print('Error getting collection: $e');
      return [];
    }
  }
}
