import 'package:Sharey/models/Coupon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CouponService {
  final CollectionReference _couponsCollection =
      FirebaseFirestore.instance.collection('coupons');

  Future<Coupon?> getCoupon(String couponId) async {
    try {
      final doc = await _couponsCollection.doc(couponId).get();
      if (doc.exists) {
        return Coupon.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        print('Coupon not found');
        Fluttertoast.showToast(
          msg: 'Coupon not found',
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
    } catch (e) {
      print('Error getting coupon: $e');
      return null;
    }
  }

  Future<void> createCoupon(Coupon coupon) async {
    // await _couponsCollection.add(coupon.toMap());
  }

  Future<void> updateCoupon(String couponId, Coupon updatedCoupon) async {
    // await _couponsCollection.doc(couponId).update(updatedCoupon.toMap());
  }

  Future<void> deleteCoupon(String couponId) async {
    await _couponsCollection.doc(couponId).delete();
  }

  Future<List<Coupon>> getUserCoupons(String userId) async {
    try {
      final querySnapshot = await _couponsCollection
          .where('couponOwners', arrayContains: userId)
          .get();
      return querySnapshot.docs
          .map((doc) => Coupon.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user coupons: $e');
      return [];
    }
  }
}
