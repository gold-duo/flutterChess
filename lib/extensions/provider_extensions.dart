import 'package:flutter/foundation.dart';

class ValueNotifierEx<T> extends ChangeNotifier implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  ValueNotifierEx(this._value) {
    if (kFlutterMemoryAllocationsEnabled) {
      ChangeNotifier.maybeDispatchObjectCreation(this);
    }
  }

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.
  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    notifyListeners();
  }

  @pragma('vm:prefer-inline')
  void markDirty()=>notifyListeners();

  @pragma('vm:prefer-inline')
  T get get=>value;

  @pragma('vm:prefer-inline')
  void update(bool Function(T thiz) block){
    if(block(value)) markDirty();
  }
  @override
  String toString() => '${describeIdentity(this)}($value)';
}

extension ValueNotifierExtensions<T extends Object> on T {
  @pragma('vm:prefer-inline')
  ValueNotifierEx<T> get notifier => ValueNotifierEx(this);
}