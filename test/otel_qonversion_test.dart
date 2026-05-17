// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:otel_qonversion/otel_qonversion.dart';
import 'package:test/test.dart';

void main() {
  group('otel_qonversion', () {
    test('suppression toggles in zone', () async {
      expect(qonversionInstrumentationSuppressed(), isFalse);
      await runWithoutQonversionInstrumentationAsync(() async {
        expect(qonversionInstrumentationSuppressed(), isTrue);
      });
      expect(qonversionInstrumentationSuppressed(), isFalse);
    });

    test('QonversionResult fields default null', () {
      const r = QonversionResult();
      expect(r.statusCode, isNull);
    });
  });
}
