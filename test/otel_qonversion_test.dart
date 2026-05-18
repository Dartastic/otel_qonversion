// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

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
