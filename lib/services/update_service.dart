import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

 class UpdateService{
static Future<void> checkForUpdate() async{
try{
  AppUpdateInfo  updateInfo = await InAppUpdate.checkForUpdate();
  if(updateInfo.updateAvailability== UpdateAvailability.updateAvailable){
    if(updateInfo.immediateUpdateAllowed){
      await InAppUpdate.performImmediateUpdate();
    }
  }
}catch (e){
  debugPrint("In-App Update Error hai: $e");
}

}
 }
