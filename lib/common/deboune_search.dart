import 'dart:async';

Timer? _debounceTimer;

void debounceSearch(void Function() callback) {
  if (_debounceTimer != null && _debounceTimer!.isActive) {
    _debounceTimer!.cancel();
  }

  _debounceTimer = Timer(const Duration(seconds: 1), () {
    callback();
  });
}
