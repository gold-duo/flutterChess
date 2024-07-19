import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

extension ListExtensions<T> on List<T> {
  // List<R> mapIndex<R>(R Function(int index, T value) action) {
  //   if (isEmpty) return [];
  //   final List<R> result = [];
  //   int i = 0;
  //   for (T it in this) {
  //     result.add(action(i++, it));
  //   }
  //   return result;
  // }
  @pragma('vm:prefer-inline')
  List<R> indexedMapToList<R>(R Function((int index, T value)) action,{bool growable=false}) =>
      indexed.map(action).toList(growable: growable);

  @pragma('vm:prefer-inline')
  List<R> map2List<R>(R  Function(T value) action,{bool growable=false}) =>
      map(action).toList(growable: growable);
}
extension List2DExtension<T> on List<List<T>>{
  @pragma('vm:prefer-inline')
  List<List<T>> clone2d({bool growable=false}) {
    return isEmpty? List.empty(growable: growable): List.generate(length, (i) => List.from(this[i],growable:growable));
  }
  @pragma('vm:prefer-inline')
  List<List<T>> reverse({bool growable=false}){
    
    return isEmpty? List.empty(growable: growable): List.generate(length, (i) => List.from(this[length-i-1],growable:growable));
  }
  List<List<T>> copyOrClone2d(List<List<T>> to,{bool growable=false}){
    if(to.length!=length) {
      return this.clone2d(growable:growable);
    }
    for( int i=0;i<to.length;i++){
      final lineTo=to[i];
      final lineFrom=this[i];
      if(lineTo.length!=lineTo.length){
        to[i]=List.from(lineFrom,growable:growable);
        continue;
      }
      lineTo.replaceRange(0, lineTo.length, lineFrom);
    }
    return to;
  }

  String list2DString([String? desc]) {
    final StringBuffer sb = StringBuffer();
    if (desc != null && desc.isNotEmpty) sb.write(desc);
    sb.writeln('[');
    forEach((it) {
      sb.write('\t[');
      final last = it.length - 1;
      for (int i = 0; i <= last; i++) {
        final c = it[i];
        sb.write(c);
        if (i != last) sb.write(',');
      }
      sb.writeln("],");
    });
    sb.writeln("];");
    return sb.toString();
  }
}

extension MapExtensions<K, V> on Map<K, V> {
  @pragma('vm:prefer-inline')
  List<T> map2List<T>(T Function( MapEntry<K, V> entry) action,{bool growable=false}) =>
      entries.map(action).toList(growable: growable);

  @pragma('vm:prefer-inline')
  List<T> indexedMapToList<T>(T Function((int index, MapEntry<K, V> entry)) action,{bool growable=false}) =>
      entries.indexed.map(action).toList();

}

extension SetExtensions<T> on Set<T>{
  @pragma('vm:prefer-inline')
  List<R> map2List<R>(R Function(T) action,{bool growable=false}) => map(action).toList(growable: growable);

  @pragma('vm:prefer-inline')
  bool equalTo(Set<T> other){
    if(other.length!=length)return false;
    for(T it in other){
      if(!contains(it)) return false;
    }
    return true;
  }
}
extension IterableExtensions<T> on Iterable<T>{
  @pragma('vm:prefer-inline')
  List<R> map2List<R>(R Function( T) action,{bool growable=false}) =>
      map(action).toList(growable: growable);
}