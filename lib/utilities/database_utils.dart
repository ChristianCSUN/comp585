import 'package:firebase_database/firebase_database.dart';
import 'package:stockappflutter/utilities/auth_utils.dart';

final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

void fetchUserFavorites(void Function(Map<String, Map<String, String>>) onDataChanged){
  String? userID = getUserID();
  final favRef = _dbRef.child("users/$userID/favorites");
  favRef.onValue.listen((event) {
    final data = event.snapshot.value as Map<dynamic, dynamic>?;
    if(data != null){
      onDataChanged(data.map((key,value) {
        return MapEntry(key as String, Map<String, String>.from(value));
      }));
    }else{
      onDataChanged({});
    }
  });
}

void addFavorite(String? name, String? symbol) async{
  String? userID = getUserID();
  final favRef = _dbRef.child("users/$userID/favorites").push();
  favRef.set({
    'name': name,
    'symbol' : symbol,
  });
}

void removeFavorite(String? symbol) async{
  String? userID = getUserID();
  final favRef = _dbRef.child("users/$userID/favorites");
  final DataSnapshot snapshot = await favRef.get();
  if(snapshot.exists){
    final favorites = Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    favorites.forEach((key, value){
      if(value['symbol'] == symbol){
        favRef.child(key).remove();
      }
    });
  }
}

void removeUserFavorites()async{
  String? userID = getUserID();
  final favRef = _dbRef.child("users/$userID/favorites");
  await favRef.remove();
}

Future<bool> isFavorite(String? symbol) async{
  String? userID = getUserID();
  final favRef = _dbRef.child("users/$userID/favorites");
  final DataSnapshot snapshot = await favRef.get();
  if(snapshot.exists){
    final favorites = Map<dynamic, dynamic>.from(snapshot.value as Map<dynamic, dynamic>);
    for(var favorite in favorites.values){
      if(favorite["symbol"] == symbol){
        return true;
      }
    }
  }
  return false;

}