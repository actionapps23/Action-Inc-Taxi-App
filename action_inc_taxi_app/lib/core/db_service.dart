import 'package:action_inc_taxi_app/core/helper_functions.dart';
import 'package:action_inc_taxi_app/core/models/car_detail_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/creds.dart';
import 'models/car_info.dart';
import 'models/driver.dart';
import 'models/rent.dart';
import 'models/renewal.dart';

class DbService {
  Future<Map<String, int>> getFleetAmountsByPeriod({
    required String periodType,
    DateTime? date,
  }) async {
    final now = date?.toUtc() ?? DateTime.now().toUtc();
    final carQuery = await _firestore.collection(carInfoCollection).get();
    final fleetTaxiNos = <String, List<String>>{};
    for (var i = 1; i <= 4; i++) {
      fleetTaxiNos[i.toString()] = [];
    }
    for (final doc in carQuery.docs) {
      final data = doc.data();
      final fleetNumber = (data['fleetNo']);
      final taxiNo = data['taxiNo'] as String?;
      if (fleetNumber != null && taxiNo != null && fleetTaxiNos.containsKey(fleetNumber)) {
        fleetTaxiNos[fleetNumber]!.add(taxiNo);
      }
    }
    final rentQuery = await _firestore.collection(rentsCollection).get();
    final rents = rentQuery.docs.map((d) => Rent.fromMap(d.data())).toList();
    String todayKey = HelperFunctions.generateDateKeyFromUtc(now.millisecondsSinceEpoch);
    String monthKey = todayKey.substring(0, 7);
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));
    int fleet1Amt = 0;
    int fleet2Amt = 0;
    int fleet3Amt = 0;
    int fleet4Amt = 0;
    for (final r in rents) {
      if (periodType == 'daily') {
        if (r.dateKey == todayKey) {
          if (fleetTaxiNos[1]!.contains(r.taxiNo)) {
            fleet1Amt += r.paymentCashCents + r.paymentGCashCents;
          } else if (fleetTaxiNos[2]!.contains(r.taxiNo)) {
            fleet2Amt += r.paymentCashCents + r.paymentGCashCents;
          } else if (fleetTaxiNos[3]!.contains(r.taxiNo)) {
            fleet3Amt += r.paymentCashCents + r.paymentGCashCents;
          } else if (fleetTaxiNos[4]!.contains(r.taxiNo)) {
            fleet4Amt += r.paymentCashCents + r.paymentGCashCents;
          }
        }
      } else if (periodType == 'monthly') {
        if (r.dateKey.startsWith(monthKey)) {
          if (fleetTaxiNos['1']!.contains(r.taxiNo)) fleet1Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['2']!.contains(r.taxiNo)) fleet2Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['3']!.contains(r.taxiNo)) fleet3Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['4']!.contains(r.taxiNo)) fleet4Amt += r.paymentCashCents + r.paymentGCashCents;
        }
      } else if (periodType == 'weekly') {
        final rentDate = DateTime.parse(r.dateKey);
        if (!rentDate.isBefore(startOfWeek) && !rentDate.isAfter(endOfWeek)) {
          if (fleetTaxiNos['1']!.contains(r.taxiNo)) fleet1Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['2']!.contains(r.taxiNo)) fleet2Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['3']!.contains(r.taxiNo)) fleet3Amt += r.paymentCashCents + r.paymentGCashCents;
          if (fleetTaxiNos['4']!.contains(r.taxiNo)) fleet4Amt += r.paymentCashCents + r.paymentGCashCents;
        }
      }
    }
    final totalAmt = fleet1Amt + fleet2Amt + fleet3Amt + fleet4Amt;
    return {
      'fleet1Amt': fleet1Amt,
      'fleet2Amt': fleet2Amt,
      'fleet3Amt': fleet3Amt,
      'fleet4Amt': fleet4Amt,
      'totalAmt': totalAmt,
    };
  }
      Future<Map<int, Map<String, int>>> getTodaysAmountByFleet() async {
        final now = DateTime.now().toUtc();
        final dateKey = HelperFunctions.generateDateKeyFromUtc(now.millisecondsSinceEpoch);
        final carQuery = await _firestore.collection(carInfoCollection).get();
        final fleetTaxiNos = <int, List<String>>{};
        for (var i = 1; i <= 4; i++) {
          fleetTaxiNos[i] = [];
        }
        for (final doc in carQuery.docs) {
          final data = doc.data();
          final fleetNumber = (data['fleetNumber'] as int?);
          final taxiNo = data['taxiNo'] as String?;
          if (fleetNumber != null && taxiNo != null && fleetTaxiNos.containsKey(fleetNumber)) {
            fleetTaxiNos[fleetNumber]!.add(taxiNo);
          }
        }
        final rentQuery = await _firestore.collection(rentsCollection)
            .where('dateKey', isEqualTo: dateKey)
            .get();
        final rents = rentQuery.docs.map((d) => Rent.fromMap(d.data())).toList();
        final result = <int, Map<String, int>>{};
        for (var i = 1; i <= 4; i++) {
          int totalCash = 0;
          int totalGCash = 0;
          for (final r in rents) {
            if (fleetTaxiNos[i]!.contains(r.taxiNo)) {
              totalCash += r.paymentCashCents;
              totalGCash += r.paymentGCashCents;
            }
          }
          result[i] = {
            'totalCash': totalCash,
            'totalGCash': totalGCash,
            'totalAmount': totalCash + totalGCash,
          };
        }
        return result;
      }
    Future<List<Rent>> fetchRentsByDateKey(String dateKey) async {
      final q = await _firestore.collection(rentsCollection)
          .where('dateKey', isEqualTo: dateKey)
          .get();
      return q.docs.map((d) => Rent.fromMap(d.data())).toList();
    }

    Future<Map<String, int>> getTodaysAmount() async {
      final now = DateTime.now().toUtc();
      final dateKey = HelperFunctions.generateDateKeyFromUtc(now.millisecondsSinceEpoch);
      final rents = await fetchRentsByDateKey(dateKey);
      int totalCash = 0;
      int totalGCash = 0;
      for (final r in rents) {
        totalCash += r.paymentCashCents;
        totalGCash += r.paymentGCashCents;
      }
      return {
        'totalCash': totalCash,
        'totalGCash': totalGCash,
        'totalAmount': totalCash + totalGCash,
      };
    }
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
