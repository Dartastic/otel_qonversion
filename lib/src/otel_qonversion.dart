// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_qonversion_suppression.dart';

class QonversionResult {
  const QonversionResult({
    this.projectKey,
    this.userId,
    this.productId,
    this.offeringId,
    this.entitlementId,
    this.isActive,
    this.store,
    this.priceAmount,
    this.currency,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? projectKey;
  final String? userId;
  final String? productId;
  final String? offeringId;
  final String? entitlementId;
  final bool? isActive;
  final String? store;
  final double? priceAmount;
  final String? currency;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class QonversionCallResult<T> {
  const QonversionCallResult({required this.value, this.result});
  final T value;
  final QonversionResult? result;
}

Future<T> tracedQonversion<T>({
  required String operation,
  required Future<QonversionCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (qonversionInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_qonversion');
  final span = t.startSpan('qonversion $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'qonversion');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.projectKey != null) {
        span.setStringAttribute('qonversion.project.key', res.projectKey!);
      }
      if (res.userId != null) {
        span.setStringAttribute('user.id', res.userId!);
      }
      if (res.productId != null) {
        span.setStringAttribute('qonversion.product.id', res.productId!);
      }
      if (res.offeringId != null) {
        span.setStringAttribute('qonversion.offering.id', res.offeringId!);
      }
      if (res.entitlementId != null) {
        span.setStringAttribute(
          'qonversion.entitlement.id',
          res.entitlementId!,
        );
      }
      if (res.isActive != null) {
        span.setBoolAttribute('qonversion.active', res.isActive!);
      }
      if (res.store != null) {
        span.setStringAttribute('qonversion.store', res.store!);
      }
      if (res.priceAmount != null) {
        span.setDoubleAttribute('qonversion.price.amount', res.priceAmount!);
      }
      if (res.currency != null) {
        span.setStringAttribute('qonversion.currency', res.currency!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('qonversion.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'qonversion.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
