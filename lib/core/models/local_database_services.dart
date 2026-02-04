import 'package:hive/hive.dart';
import 'package:news_app/core/utils/app_constants.dart';

class LocalDatabaseServices {

  Future<void > saveData <T>(String key , T value) async{
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    await box.put(key, value);
  }
  Future<T> getData <T> (String key) async{
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    return box.get(key);
  }

  Future<void> deleteData (String key) async{
    final box = await Hive.openBox(AppConstants.localDatabaseBoxName);
    await box.delete(key);
  }

}