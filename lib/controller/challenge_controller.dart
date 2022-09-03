import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

enum CalculType {INCREMENT, DECREMENT}

class ChallengeController extends GetxController{
  RxList myChallenges = [].obs;
  RxBool ischecked = false.obs;
  RxInt count = 0.obs;
  //RxBool isEditMyProfile = false.obs;


  @override
  void onInit(){
    myChallenges(null);
    super.onInit();
  }

  void getMyChallenges(){
    //isEditMyProfile(!isEditMyProfile.value);
  }

  void changeLoveCount(String docID, CalculType type){
    final challengeDoc = FirebaseFirestore.instance
        .collection('/challenge').doc(docID);
    QueryDocumentSnapshot snapshot = challengeDoc.snapshots().first as QueryDocumentSnapshot<Object?>;
    print(snapshot.get('love'));

    if(type == CalculType.INCREMENT) {
      challengeDoc.update(
          {'love': FieldValue.increment(1)});
      count = snapshot.get('love') + 1;
    }
    else {
      challengeDoc.update(
          {'love': FieldValue.increment(-1)});
      count = snapshot.get('love') - 1;
    }
  }
}