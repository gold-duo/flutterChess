typedef Stack<T> = List<T>;

extension StackExtension<T> on Stack<T> {
  @pragma('vm:prefer-inline')
  void push(T value) => add(value);

  @pragma('vm:prefer-inline')
  T pop() => removeLast();

  T? peek() {
    final last=length-1;
    return last<0? null: this[last];
  }
}
