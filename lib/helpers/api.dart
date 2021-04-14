import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:http/http.dart';

class ApiHelper with ChangeNotifier {
  static const String api = 'https://control.harvest.qa/api/';

  // static const Map<String, String> headers = {
  //   'Accept': 'application/json',
  //   'Accept-Language':' LangProvider().getLocaleCode()',
  // };
  //
  // static const Map<String, String> headersWithAuth = {
  //   'Accept': 'application/json',
  //   'Accept-Language': 'en',
  //   'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImMzMDZlNjE3Y2QwYjM4OGQyOTU2ODc1ZWNlN2VhYTllOGYxZTBhMDg4ZTI2YjYzMjA4OTUxMjI4NzkwMTNkMWEwMzY2Y2YzZGMyZjg3MGM4In0.eyJhdWQiOiIxIiwianRpIjoiYzMwNmU2MTdjZDBiMzg4ZDI5NTY4NzVlY2U3ZWFhOWU4ZjFlMGEwODhlMjZiNjMyMDg5NTEyMjg3OTAxM2QxYTAzNjZjZjNkYzJmODcwYzgiLCJpYXQiOjE1OTkzNDEwOTUsIm5iZiI6MTU5OTM0MTA5NSwiZXhwIjoxNjMwODc3MDk1LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.ntX-amCRR3Yk9ORuvspYZrqsTdE6B2ulbDfYxA4a6UAPPQLnP9wZ5zmFeydLBWOublefUu7OnQtff_E7_YkOkdOVbVFvfsZfVRuntYQWQzmaRk0QMdrZ-2klr6HVfO5IBYuQFwkDtnv3So_V4baxput20CindGTkvIuuzZxFG4NWLL4V2av0rHPRsbw9shrihQQAOZHuUCDqq53edHUBgwRbAs-BNkBa0YIyiqQv2GnBknxbAleUnoapbpcP9YCEgG0NB-c6hN9QOpha5dvE7Du6QPguOwj5FqPouH98YLPLS2LgUtr_cbjLkTaUGH5_QH15UeJpS49i7SSQk5DC_Ine_6xCmpfhCIxhPOKed39Gng0utgHKMwehW8iByVQbzwfA72n1ELhePjx6KZFqU0kpsRQ51LBCIkFqvmmSsi5VQo3071RO05D0k5baz_Q8Otclk03tpSu_JqNHDIRy0-88x-MphYEk-s5VckkBYwu7tNXK-dHMUZmoEEHa2qlS9f7ehEJ6MBODzMT5QGAr-qRr2sfaAXeMVEKxCIywq3PpQnFHbwUsK6isZDqKeEU820cN3yHuqzpNiMJZ0kAJkrMtSCKRT4C3mZ6leloQQE1LoSH-Rz99ueNAlTJoW3IZ_nQHUIYQntZFOZhkaAl8WcANEb2xUZlUIz4_XOIDdh0'
  // };
  //
  // static const Map<String, String> headersWithAuthDriver = {
  //   'Accept': 'application/json',
  //   'Accept-Language': 'en',
  //   'Authorization':'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImJiYzg0ODI5MjkxZmEzN2IwNDg1NGYxMjE3NzdiNDBhYzE3YzE3ZTI1NmQ4YmI2OTM4YTNkYTU2MmM3Nzg2ZTVhMzA2ZTY1YTQ3ZWNhZjY3In0.eyJhdWQiOiIxIiwianRpIjoiYmJjODQ4MjkyOTFmYTM3YjA0ODU0ZjEyMTc3N2I0MGFjMTdjMTdlMjU2ZDhiYjY5MzhhM2RhNTYyYzc3ODZlNWEzMDZlNjVhNDdlY2FmNjciLCJpYXQiOjE2MDAyOTE5NjAsIm5iZiI6MTYwMDI5MTk2MCwiZXhwIjoxNjMxODI3OTYwLCJzdWIiOiI0Iiwic2NvcGVzIjpbXX0.oEGRlf1Hrz9IjKzSYxwMah4ZZx3-kTn9aHxotOKW89VNsRj-hswB6U7eX0nPuw7cHwXL8BLx7nGEzR71aqPIJ6u263QHoYHXXrSoaGTT-q-LTRkDeiCHf1vbhigLwlN0QI8bqIiQKa-8kMEr1-4RohJv-8GcyCxMW3wtaA3pcrOkVjNGkKASlJtGrVfhiaN-E2Zk8FBzsvrTciEQrGTp30m_Awsuv9py9yQiznInNKZrVWI5z477ZI4DDZxGR4jh5Wk2RExE7KDc1bsS-yEOB-08yiJ8gcWnh7v7DR8cc1Ee45k4DFD8pvQwfovVp6bALnt1yeCpRAkBPx5uFXcIuoYr7qMPgfFUWik9lYOBfNWi_PkmbdjuA7OVbvtEozUFbgRSW2CCx2jA0756jOYhgNjQMCG3B_LxtkmYtyLXtJhTBP923H0dvHYfK1GDNw2Z0tMCnyO4xsC6gaIvCgtGpk73DK5a5iHk-rUmfpa925yLH4f6zSFSRqBPkwFbFR6jwOfx1usJG0oTmQKlokFUw8OlGriZzUWAU9OgkYDPcAAFYiyV7FEj-oS_djLUlngtVJwlvjurWxPIRdcMp3OExS1K5GEGSiK5PcTPuJ_MQ-rUPeRWv8rTOpgcYzIZKTG_TxC0z3VfZ1f35EcneyL-SxV01q-0ZRrl6L7iG1EKbZI'
  // };

  // Category selectedCategory;
  //
  // setCat(Category cat){
  //   selectedCategory = cat;
  // }


  // Future<List<Category>> getCategories() async {
  //   var request = await get(api + 'getCategories', headers: headers);
  //   var response = json.decode(request.body);
  //   List values = response['items'];
  //   List<Category> _category = [];
  //   values.forEach((element) {
  //     Category category = Category.fromJson(element);
  //     _category.add(category);
  //   });
  //   notifyListeners();
  //   return _category;
  // }

// Future<List<Products>> getProductsByCategories(Category category) async {
//   var request = await get(api + 'getProductsByCategoryId/${category.id??1}', headers: headers);
//   var response = json.decode(request.body);
//   List values = response['items'];
//   List<Products> _products = [];
//   values.forEach((element) {
//     Products products = Products.fromJson(element);
//     _products.add(products);
//   });
//   return _products;
// }
}
