// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_airbyte_suppression.dart';

class AirbyteResult {
  /// Creates a result.
  const AirbyteResult({
    this.deployment,
    this.workspaceId,
    this.sourceId,
    this.sourceDefinition,
    this.sourceDockerImage,
    this.destinationId,
    this.destinationDefinition,
    this.destinationDockerImage,
    this.connectionId,
    this.connectionName,
    this.namespace,
    this.streamName,
    this.syncMode,
    this.jobId,
    this.jobStatus,
    this.attemptNumber,
    this.recordsEmitted,
    this.recordsCommitted,
    this.bytesEmitted,
    this.bytesCommitted,
    this.streamsCount,
    this.durationMs,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? deployment;
  final String? workspaceId;
  final String? sourceId;
  final String? sourceDefinition;
  final String? sourceDockerImage;
  final String? destinationId;
  final String? destinationDefinition;
  final String? destinationDockerImage;
  final String? connectionId;
  final String? connectionName;
  final String? namespace;
  final String? streamName;
  final String? syncMode;
  final int? jobId;
  final String? jobStatus;
  final int? attemptNumber;
  final int? recordsEmitted;
  final int? recordsCommitted;
  final int? bytesEmitted;
  final int? bytesCommitted;
  final int? streamsCount;
  final int? durationMs;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class AirbyteCallResult<T> {
  /// Creates a call result.
  const AirbyteCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final AirbyteResult? result;
}

Future<T> tracedAirbyte<T>({
  required String operation,
  required Future<AirbyteCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (airbyteInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_airbyte');
  final span = t.startSpan('airbyte $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'airbyte')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.deployment != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.deployment', res.deployment!)]));
      }
      if (res.workspaceId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('airbyte.workspace.id', res.workspaceId!)
        ]));
      }
      if (res.sourceId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.source.id', res.sourceId!)]));
      }
      if (res.sourceDefinition != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'airbyte.source.definition', res.sourceDefinition!)
        ]));
      }
      if (res.sourceDockerImage != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'airbyte.source.docker_image', res.sourceDockerImage!)
        ]));
      }
      if (res.destinationId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('airbyte.destination.id', res.destinationId!)
        ]));
      }
      if (res.destinationDefinition != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'airbyte.destination.definition', res.destinationDefinition!)
        ]));
      }
      if (res.destinationDockerImage != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'airbyte.destination.docker_image', res.destinationDockerImage!)
        ]));
      }
      if (res.connectionId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('airbyte.connection.id', res.connectionId!)
        ]));
      }
      if (res.connectionName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'airbyte.connection.name', res.connectionName!)
        ]));
      }
      if (res.namespace != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.namespace', res.namespace!)]));
      }
      if (res.streamName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.stream.name', res.streamName!)]));
      }
      if (res.syncMode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.sync.mode', res.syncMode!)]));
      }
      if (res.jobId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('airbyte.job.id', res.jobId!)]));
      }
      if (res.jobStatus != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.job.status', res.jobStatus!)]));
      }
      if (res.attemptNumber != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('airbyte.job.attempt', res.attemptNumber!)]));
      }
      if (res.recordsEmitted != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('airbyte.records.emitted', res.recordsEmitted!)
        ]));
      }
      if (res.recordsCommitted != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'airbyte.records.committed', res.recordsCommitted!)
        ]));
      }
      if (res.bytesEmitted != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('airbyte.bytes.emitted', res.bytesEmitted!)
        ]));
      }
      if (res.bytesCommitted != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('airbyte.bytes.committed', res.bytesCommitted!)
        ]));
      }
      if (res.streamsCount != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('airbyte.streams.count', res.streamsCount!)
        ]));
      }
      if (res.durationMs != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('airbyte.duration_ms', res.durationMs!)]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('airbyte.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.jobStatus == 'failed' ||
          res.jobStatus == 'incomplete';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'airbyte.error')
        ]));
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
