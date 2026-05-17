# otel_qonversion

Dartastic OpenTelemetry bridge for Qonversion (IAP subscription analytics + paywalls).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_qonversion/otel_qonversion.dart';

await tracedQonversion<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return QonversionCallResult(value: r, result: QonversionResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutQonversionInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
