import 'package:get/get.dart';

class ChallengeController extends GetxController{
  RxList myChallenges = [].obs;
  //RxBool isEditMyProfile = false.obs;

  @override
  void onInit(){
    myChallenges(null);
    super.onInit();
  }

  void getMyChallenges(){
    //isEditMyProfile(!isEditMyProfile.value);
  }
}