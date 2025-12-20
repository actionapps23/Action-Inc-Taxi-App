import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/creds.dart';
import 'models/car_info.dart';
import 'models/driver.dart';
import 'models/rent.dart';
import 'models/renewal.dart';

class DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String credsCollection = 'creds';
  final String carsCollection = 'car_details';
  final String carInfoCollection = 'car_info';
  final String driversCollection = 'drivers';
  final String rentsCollection = 'rents';
  final String renewalsCollection = 'renewals';
  final String draftsCollection = 'drafts';

  Future<Creds?> loginWithEmployeeId(
    String employeeId,
    String hashPassword,
  ) async {
    try {
      final doc = await _firestore
          .collection(credsCollection)
          .doc(employeeId)
          .get();
      if (!doc.exists) return null;
      final creds = Creds.fromMap(doc.data()!);
      if (creds.hashPassword == hashPassword) {
        return creds;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // Add more database interaction methods as needed
  Future<CarInfo?> getCarByTaxiNo(String taxiNo) async {
    try {
      final q = await _firestore
          .collection(carsCollection)
          .where('taxiNo', isEqualTo: taxiNo)
          .limit(1)
          .get();
      if (q.docs.isEmpty) return null;
      final m = q.docs.first.data();
      return CarInfo.fromMap(m..['id'] = q.docs.first.id);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveDriver(Driver d) async {
    try {
      final id = d.id;
      await _firestore.collection(driversCollection).doc(id).set(d.toMap());
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveCar(CarInfo c) async {
    try {
      final taxiNo = c.taxiNo;
      final map = c.toMap();
      await _firestore.collection(carInfoCollection).doc(taxiNo).set(map);
      return taxiNo;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveRent(Rent r) async {
    try {
      final doc = await _firestore.collection(rentsCollection).add(r.toMap());
      return doc.id;
    } catch (e) {
      rethrow;
    }
  }
  

  Future<void> saveCarDetailInfo({
    Map<String, dynamic>? rent,
    Map<String, dynamic>? driver,
    Map<String, dynamic>? car,
  }) async {
    try {
      final ref = _firestore.collection(carsCollection).doc(car?['taxiNo']);
      final payload = <String, dynamic>{
        'rent': rent,
        'driver': driver,
        'car': car,
        'updatedAtUtc': DateTime.now().toUtc().millisecondsSinceEpoch,
      };
      await ref.set(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<CarDetailModel?> getTaxiDetailInfo(String taxiNo, String regNo) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc;
      if (taxiNo.isNotEmpty) {
        doc = await _firestore.collection(carsCollection).doc(taxiNo).get();
      } else if (regNo.isNotEmpty) {
        final q = await _firestore
            .collection(carsCollection)
            .where('regNo', isEqualTo: regNo)
            .limit(1)
            .get();
        if (q.docs.isEmpty) return null;
        doc = q.docs.first;
      } else {
        return null;
      }
      if (!doc.exists) return null;
      final data = doc.data();
      final rentMap = data?['rent'] as Map<String, dynamic>?;
      final driverMap = data?['driver'] as Map<String, dynamic>?;
      final carMap = data?['car'] as Map<String, dynamic>?;
      final rent = rentMap != null ? Rent.fromMap(rentMap) : null;
      final driver = driverMap != null ? Driver.fromMap(driverMap) : null;
      final carInfo = carMap != null ? CarInfo.fromMap(carMap) : null;
      return CarDetailModel(carInfo: carInfo!, driver: driver!, rent: rent!);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getDraftForTaxi(String taxiNo) async {
    try {
      final doc = await _firestore
          .collection(draftsCollection)
          .doc(taxiNo)
          .get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveRenewal(Renewal r) async {
    try {
      final col = _firestore.collection(renewalsCollection);
      // Always create a new document, ignore r.id
      final ref = col.doc();
      final map = r.toMap()..['id'] = ref.id;
      await ref.set(map);
      return ref.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<Renewal?> getRenewalByTaxi(String taxiNo) async {
    try {
      final q = await _firestore
          .collection(renewalsCollection)
          .where('taxiNo', isEqualTo: taxiNo)
          .limit(1)
          .get();
      if (q.docs.isEmpty) return null;
      final data = q.docs.first.data()..['id'] = q.docs.first.id;
      return Renewal.fromMap(data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllRenewals() async {
    try {
      final q = await _firestore.collection(renewalsCollection).get();
      return q.docs.map((d) => d.data()..['id'] = d.id).toList();
    } catch (e) {
      rethrow;
    }
  }
}
