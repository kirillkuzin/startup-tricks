import 'dart:js_interop';
import 'dart:js_util' as js_util;

@JS()
external String _getTelegramInitDataRaw();

@JS()
external String _getTelegramPayload();

@JS('closeWebApp')
external void _closeWebApp();

@JS('sendResult')
external void _sendResult(JSAny? data);

String getTelegramInitDataRaw() {
  return _getTelegramInitDataRaw();
}

String getTelegramPayload() {
  return _getTelegramPayload();
}

Future closeWebApp() {
  _closeWebApp();
}

Future sendDataToTg(dynamic data) {
  final JSAny jsObject = js_util.jsify(data);
  _sendResult(jsObject);
}
