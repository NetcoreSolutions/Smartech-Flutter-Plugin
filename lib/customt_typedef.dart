typedef CustomHTMLCallback = Future<dynamic> Function(
    Map<String, dynamic>? payload);
typedef OnhandleDeeplinkAction = Function(String? deeplinkigUrl,
    Map<dynamic, dynamic>? payload, bool? isAfterTerminated);
