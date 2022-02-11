import 'package:abg_utils/abg_utils.dart';

bool statShow = false;
final List<Stat> _stat = [];
int _serverCount = 0;
int _allCountCache = 0;

addStat(String source, int count, {bool cache = false}){
  if (!statShow)
    return;
  _stat.add(Stat(source, count, cache));
  if (cache)
    _allCountCache += count;
  else
    _serverCount += count;

  _debugStat();
}

_debugStat(){
  dprint("======================= Firebase Statistics =======================");

  int _local = 0;
  int _server = 0;
  for (var item in _stat){
    if (item.cache)
      _local += item.count;
    else
      _server += item.count;
    dprint("${item.cache ? "(LOCAL CACHE)": "(FROM SERVER)"} source: ${item.source}, "
        "count: ${item.count} (${item.cache ?_local : _server})");
  }
  double p1 = (_serverCount+_allCountCache)/100;
  dprint("read from server=$_serverCount *** from local cache=$_allCountCache (${(_allCountCache/p1).toStringAsFixed(0)}%)");
  dprint("======================= Firebase Statistics End =======================");
}

class Stat{
  final String source;
  final int count;
  final bool cache;
  Stat(this.source, this.count, this.cache);
}
