import '../../abg_utils.dart';

int ratingCount = 0;
int rating1 = 0;
int rating2 = 0;
int rating3 = 0;
int rating4 = 0;
int rating5 = 0;
double rating = 0;
bool ratingsLoad = false;
double ratingIndex1 = 0;
double ratingIndex2 = 0;
double ratingIndex3 = 0;
double ratingIndex4 = 0;
double ratingIndex5 = 0;

Future<String?> loadRatings(String providerid) async{
  try{
    rating1 = 0;
    rating2 = 0;
    rating3 = 0;
    rating4 = 0;
    rating5 = 0;

    List<ProductData> _list = await dbGetAllDocumentInTable("service", field1: "providers", arrayContains1: providerid);
    // var querySnapshot = await FirebaseFirestore.instance.collection("service").
    // where("providers", arrayContains: providerData.id).get();

    for (var _service in _list) {
      // var _data = result.data();
      // print("loadRatings $_data");
      // var _service = ProductData.fromJson(result.id, _data);
      rating1 += _service.rating1;
      rating2 += _service.rating2;
      rating3 += _service.rating3;
      rating4 += _service.rating4;
      rating5 += _service.rating5;
    }
    // 2 - ?%
    ratingCount = rating1+rating2+rating3+rating4+rating5; // 5 - 100%
    rating = (rating1*1 + rating2*2 + rating3*3 + rating4*4 + rating5*5)/ratingCount;
    ratingsLoad = true;
    ratingIndex1 = (100/ratingCount*rating1)/100;
    ratingIndex2 = (100/ratingCount*rating2)/100;
    ratingIndex3 = (100/ratingCount*rating3)/100;
    ratingIndex4 = (100/ratingCount*rating4)/100;
    ratingIndex5 = (100/ratingCount*rating5)/100;
  }catch(ex){
    return "loadRatings " + ex.toString();
  }
  return null;
}