import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/creds.dart';
import 'models/car_info.dart';
import 'models/driver.dart';
import 'models/rent.dart';
import 'models/renewal.dart';
import 'package:uuid/uuid.dart';

class DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String credsCollection = 'creds';
  final String carsCollection = 'cars';
  final String driversCollection = 'drivers';
  final String rentsCollection = 'rents';
  final String renewalsCollection = 'renewals';
  final String draftsCollection = 'drafts';
  final _uuid = Uuid();

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
      final id = d.id.isNotEmpty ? d.id : _uuid.v4();
      await _firestore.collection(driversCollection).doc(id).set(d.toMap());
      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> saveCar(CarInfo c) async {
    try {
      final id = c.id.isNotEmpty ? c.id : c.taxiNo;
      final map = c.toMap();
      map['id'] = id;
      await _firestore.collection(carsCollection).doc(id).set(map);
      return id;
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

  /// Save a draft for a taxi. Drafts are stored in `drafts` collection with doc id equal to taxiNo.
  /// The payload will contain optional 'rent' and 'driver' maps.
  Future<void> saveDraftForTaxi({
    required String taxiNo,
    Map<String, dynamic>? rent,
    Map<String, dynamic>? driver,
    Map<String, dynamic>? car,
  }) async {
    try {
      final ref = _firestore.collection(draftsCollection).doc(taxiNo);
      final payload = <String, dynamic>{
        'taxiNo': taxiNo,
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

  /// Retrieve draft payload for a taxi if exists.
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
      if (r.id != null && r.id!.isNotEmpty) {
        final id = r.id!;
        final map = r.toMap()..['id'] = id;
        await col.doc(id).set(map);
        return id;
      } else {
        final ref = col.doc();
        final map = r.toMap()..['id'] = ref.id;
        await ref.set(map);
        return ref.id;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveRenewals(List<Renewal> list) async {
    final batch = _firestore.batch();
    final col = _firestore.collection(renewalsCollection);
    for (final r in list) {
      if (r.id != null && r.id!.isNotEmpty) {
        final ref = col.doc(r.id);
        final map = r.toMap()..['id'] = r.id;
        batch.set(ref, map);
      } else {
        final ref = col.doc();
        final map = r.toMap()..['id'] = ref.id;
        batch.set(ref, map);
      }
    }
    await batch.commit();
  }

  Future<List<Renewal>> getRenewalsByTaxi(String taxiNo) async {
    try {
      final q = await _firestore
          .collection(renewalsCollection)
          .where('taxiNo', isEqualTo: taxiNo)
          .get();
      return q.docs
          .map((d) => Renewal.fromMap(d.data()..['id'] = d.id))
          .toList();
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
