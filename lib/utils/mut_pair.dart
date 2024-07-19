class MutPair<A, B> {
  A first;
  B second;

  MutPair(this.first, this.second);

  void setValue(A first,B second){
    this.first=first;
    this.second=second;
  }
  void copy( MutPair<A,B> pair){
    first=pair.first;
    second=pair.second;
  }
  @override
  String toString() {
    return 'MutPair{first:$first, second:$second}';
  }

  MutPair.from(MutPair mutPair):this(mutPair.first,mutPair.second);

  @override
  bool operator ==(Object other) =>
      // identical(this, other) ||
          other is MutPair &&
              runtimeType == other.runtimeType &&
              first == other.first &&
              second == other.second;

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}
