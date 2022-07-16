// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'cart.dart';
import 'pharmacyUser.dart';

class Order {
  String id;
  PharmacyUser user;
  List<Cart> listCart;
  num price;
  String status;
  DateTime date;
  String method;
  Order({
    required this.id,
    required this.user,
    required this.listCart,
    required this.price,
    required this.status,
    required this.date,
    required this.method,
  });

  Order copyWith({
    String? id,
    PharmacyUser? user,
    List<Cart>? listCart,
    num? price,
    String? status,
    DateTime? date,
    String? method,
  }) {
    return Order(
      id: id ?? this.id,
      user: user ?? this.user,
      listCart: listCart ?? this.listCart,
      price: price ?? this.price,
      status: status ?? this.status,
      date: date ?? this.date,
      method: method ?? this.method,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'listCart': listCart.map((x) => x.toMap()).toList(),
      'price': price,
      'status': status,
      'date': date.millisecondsSinceEpoch,
      'method': method,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      user: PharmacyUser.fromMap(map['user'] as Map<String, dynamic>),
      listCart: List<Cart>.from(
        (map['listCart'] as List<dynamic>).map<Cart>(
          (x) => Cart.fromMap(x as Map<String, dynamic>),
        ),
      ),
      price: map['price'] as num,
      status: map['status'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      method: map['method'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Order.fromJson(String source) =>
      Order.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Order(id: $id, user: $user, listCart: $listCart, price: $price, status: $status, date: $date, method: $method)';
  }

  @override
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user == user &&
        listEquals(other.listCart, listCart) &&
        other.price == price &&
        other.status == status &&
        other.date == date &&
        other.method == method;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        user.hashCode ^
        listCart.hashCode ^
        price.hashCode ^
        status.hashCode ^
        date.hashCode ^
        method.hashCode;
  }
}

Order dummyOrder = Order(
  id: '',
  user: dummyUser,
  date: DateTime.now(),
  listCart: [],
  price: 0,
  status: '',
  method: 'Cash',
);
