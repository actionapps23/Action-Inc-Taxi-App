import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<List<String>> uploadFiles(List<PlatformFile> files, {String folder = 'maintainance_attachments'}) async {
    List<String> downloadUrls = [];
    for (final file in files) {
      try {
        final fileName = file.name;
        final ref = _storage.ref().child('$folder/$fileName');
        UploadTask uploadTask;
        if (file.bytes != null) {
          uploadTask = ref.putData(file.bytes!);
        } else if (file.path != null) {
          uploadTask = ref.putFile(File(file.path!));
        } else {
          continue;
        }
        final snapshot = await uploadTask;
        final url = await snapshot.ref.getDownloadURL();
        downloadUrls.add(url);
      } catch (e) {
        continue;
      }
    }
    return downloadUrls;
  }
}
