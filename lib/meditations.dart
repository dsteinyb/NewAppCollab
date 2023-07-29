import 'package:firebase_storage/firebase_storage.dart';

class Meditations {
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  //final player = AudioPlayer();

  Future<List<String>> listMeds() async {
    final meds = await storageRef.child("meditations").listAll();
    final List<String> audioUrls = [];
    for (var item in meds.items) {
      var url = await item.getDownloadURL();
      //print(item);
      audioUrls.add(url);
      //player.play(UrlSource(url));
      //await Future.delayed(Duration(seconds: 3)); //pause between sounds
    }
    return audioUrls;
    /* var audRef = storageRef.child('meditations/sample-12s.mp3');
    var url = await audRef.getDownloadURL();
    player.play(UrlSource(url)); */
  }
}
