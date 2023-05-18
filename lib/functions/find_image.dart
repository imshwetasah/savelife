import 'package:savelife/constants/image_strings.dart';

findImage(bloodGroupRequired) {
  if (bloodGroupRequired == 'A+') {
    return aAPositive;
  } else if (bloodGroupRequired == 'A-') {
    return aANegative;
  } else if (bloodGroupRequired == 'B+') {
    return aBPositive;
  } else if (bloodGroupRequired == 'B-') {
    return aBNegative;
  } else if (bloodGroupRequired == 'AB+') {
    return aABPositive;
  } else if (bloodGroupRequired == 'AB-') {
    return aABNegative;
  } else if (bloodGroupRequired == 'O+') {
    return aOPositive;
  } else if (bloodGroupRequired == 'O-') {
    return aONegative;
  }
}
