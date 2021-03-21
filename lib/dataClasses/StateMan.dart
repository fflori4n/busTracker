import 'package:rxdart/rxdart.dart';

class StateMan{
  BehaviorSubject _reDrawInfoBrd = BehaviorSubject.seeded(0);

  Stream get stream$ => _reDrawInfoBrd.stream;

  int get reDrawInfoBrd => _reDrawInfoBrd.value;
  redRawInfoBrd(){
    _reDrawInfoBrd.add(reDrawInfoBrd);
  }
}