// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_airbyte_suppression.dart';

class AirbyteResult {
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

class AirbyteCallResult<T> {
  const AirbyteCallResult({required this.value, this.result});
  final T value;
  final AirbyteResult? result;
}

Future<T> tracedAirbyte<T>({
  required String operation,
  required Future<AirbyteCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (airbyteInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_airbyte');
  final span = t.startSpan('airbyte $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'airbyte');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.deployment != null) {
        span.setStringAttribute('airbyte.deployment', res.deployment!);
      }
      if (res.workspaceId != null) {
        span.setStringAttribute('airbyte.workspace.id', res.workspaceId!);
      }
      if (res.sourceId != null) {
        span.setStringAttribute('airbyte.source.id', res.sourceId!);
      }
      if (res.sourceDefinition != null) {
        span.setStringAttribute(
            'airbyte.source.definition', res.sourceDefinition!);
      }
      if (res.sourceDockerImage != null) {
        span.setStringAttribute(
            'airbyte.source.docker_image', res.sourceDockerImage!);
      }
      if (res.destinationId != null) {
        span.setStringAttribute('airbyte.destination.id', res.destinationId!);
      }
      if (res.destinationDefinition != null) {
        span.setStringAttribute(
            'airbyte.destination.definition', res.destinationDefinition!);
      }
      if (res.destinationDockerImage != null) {
        span.setStringAttribute(
            'airbyte.destination.docker_image', res.destinationDockerImage!);
      }
      if (res.connectionId != null) {
        span.setStringAttribute('airbyte.connection.id', res.connectionId!);
      }
      if (res.connectionName != null) {
        span.setStringAttribute('airbyte.connection.name', res.connectionName!);
      }
      if (res.namespace != null) {
        span.setStringAttribute('airbyte.namespace', res.namespace!);
      }
      if (res.streamName != null) {
        span.setStringAttribute('airbyte.stream.name', res.streamName!);
      }
      if (res.syncMode != null) {
        span.setStringAttribute('airbyte.sync.mode', res.syncMode!);
      }
      if (res.jobId != null) {
        span.setIntAttribute('airbyte.job.id', res.jobId!);
      }
      if (res.jobStatus != null) {
        span.setStringAttribute('airbyte.job.status', res.jobStatus!);
      }
      if (res.attemptNumber != null) {
        span.setIntAttribute('airbyte.job.attempt', res.attemptNumber!);
      }
      if (res.recordsEmitted != null) {
        span.setIntAttribute('airbyte.records.emitted', res.recordsEmitted!);
      }
      if (res.recordsCommitted != null) {
        span.setIntAttribute(
            'airbyte.records.committed', res.recordsCommitted!);
      }
      if (res.bytesEmitted != null) {
        span.setIntAttribute('airbyte.bytes.emitted', res.bytesEmitted!);
      }
      if (res.bytesCommitted != null) {
        span.setIntAttribute('airbyte.bytes.committed', res.bytesCommitted!);
      }
      if (res.streamsCount != null) {
        span.setIntAttribute('airbyte.streams.count', res.streamsCount!);
      }
      if (res.durationMs != null) {
        span.setIntAttribute('airbyte.duration_ms', res.durationMs!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('airbyte.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.jobStatus == 'failed' ||
          res.jobStatus == 'incomplete';
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'airbyte.error');
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
