import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dairy_track_admin/core/error/firebase_auth_exception.dart';
import 'package:dairy_track_admin/core/utils/utils.dart';

class DataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //------------read all stream-----------------
  Stream<List<Map<String, dynamic>>> featchAll(String collection,
      [String? field, String? id]) {
    try {
      if (field != null && id != null) {
        return _firestore
            .collection(collection)
            .where(field, isEqualTo: id)
            .snapshots()
            .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
      }
      return _firestore.collection(collection).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => doc.data()).toList();
      });
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
  }

//------------------------read all async----------------
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    try {
      var data = await _firestore.collection(collection).get();

      return data.docs.map((element) => element.data()).toList();
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //--------------read one-----------------------
  Future<Map<String, dynamic>> getOne(String collection, String id) async {
    try {
      final snapshot = await _firestore.collection(collection).doc(id).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
      throw 'could not find the data';
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //----------------------edit--------------
  Future<bool> edit(
      String id, String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
      return true;
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //-----------------delete----------------
  Future<bool> delete(String id, String collection) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
  }

//-----------create-----------------------
  Future<String?> create(String collection, Map<String, dynamic> data,
      [String? id]) async {
    try {
      if (id == null) {
        final docs = await _firestore.collection(collection).add(data);
        await _firestore
            .collection(collection)
            .doc(docs.id)
            .update({'id': docs.id});
        return docs.id;
      } else {
        await _firestore.collection(collection).doc(id).set(data);
      }
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      throw e.toString();
    }
    return null;
  }

  Future<bool> checkQuantityUpdated(String id) async {
    try {
      final data = await _firestore
          .collection('delivery datasource')
          .where('date', isEqualTo: Utils.formatDate(DateTime.now()))
          .where('driver', isEqualTo: id)
          .get();
      return data.docChanges.isNotEmpty;
    } on FirebaseException catch (e) {
      throw FirebaseExceptions.handleFirebaseExceptions(e);
    } catch (e) {
      return false;
    }
  }
}
