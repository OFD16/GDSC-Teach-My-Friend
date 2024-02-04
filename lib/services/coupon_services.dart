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
    try {
      await _couponsCollection.doc(coupon.id).set(coupon.toJson());
      Fluttertoast.showToast(
        msg: 'Coupon created successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error creating coupon: $e');
      Fluttertoast.showToast(
        msg: 'Coupon created failed please try again',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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

  Future<List<Coupon>> getAvailableCoupons({bool isFiltered = false}) async {
    try {
      final querySnapshot = await _couponsCollection.get();
      if (isFiltered) {
        return querySnapshot.docs
            .map((doc) => Coupon.fromJson(doc.data() as Map<String, dynamic>))
            .where((coupon) => coupon.enable == true)
            .toList();
      }
      return querySnapshot.docs
          .map((doc) => Coupon.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting available coupons: $e');
      return [];
    }
  }

  Future<Coupon?> findCouponByBrand(String brand) async {
    try {
      final querySnapshot = await _couponsCollection
          .where('brand', isEqualTo: brand)
          .limit(1)
          .get();
      return Coupon.fromJson(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error finding coupon by brand: $e');
      return null;
    }
  }

  Future<bool> removeCoupon(Coupon coupon) async {
    try {
      coupon.enable == false ? coupon.enable = true : coupon.enable = false;
      await _couponsCollection.doc(coupon.id).update(coupon.toJson());
      Fluttertoast.showToast(
        msg: 'Coupon disabled successfully',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return true;
    } catch (e) {
      print('Error removing coupon: $e');
      Fluttertoast.showToast(
        msg: 'Coupon disabled failed please try again',
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }
}
