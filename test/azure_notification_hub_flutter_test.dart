import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:azure_notification_hub_flutter/azure_notification_hub_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('azure_notification_hub_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
