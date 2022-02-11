import '../../abg_utils.dart';

StatusData? firstStatus;
StatusData? cancelStatus;
StatusData? acceptStatus;
StatusData? finishStatus;

initStatuses(List<StatusData> _statuses){
  bool _first = true;
  bool _second = false;
  for (var item in _statuses){
    if (_first){
      firstStatus = item;
      _first = false;
      _second = true;
      continue;
    }
    if (item.cancel) {
      cancelStatus = item;
      continue;
    }else {
      if (_second) {
        acceptStatus = item;
        _second = false;
        continue;
      }
      finishStatus = item;
    }
  }
}