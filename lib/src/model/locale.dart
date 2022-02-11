import '../../abg_utils.dart';

String getTextByLocale(List<StringData> _data, String locale){
  for (var item in _data)
    if (item.code == locale)
      if (item.text.isNotEmpty)
        return item.text;
  for (var item in _data)
    if (item.code == "en")
      if (item.text.isNotEmpty)
        return item.text;
  for (var item in _data)
    if (item.text.isNotEmpty)
      return item.text;
  return "";
}
