// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_airbyte/otel_airbyte.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_airbyte-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('sync.job records records + bytes', () async {
    await tracedAirbyte<String>(
      operation: 'connection.sync',
      invoke: () async => const AirbyteCallResult(
        value: 'ok',
        result: AirbyteResult(
          connectionName: 'salesforce_to_postgres',
          sourceDefinition: 'salesforce',
          destinationDefinition: 'postgres',
          syncMode: 'incremental_append',
          jobId: 12345,
          jobStatus: 'succeeded',
          recordsEmitted: 5000,
          recordsCommitted: 5000,
          bytesCommitted: 1048576,
          streamsCount: 8,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('airbyte connection.sync')!);
    expect(a['airbyte.source.definition'], 'salesforce');
    expect(a['airbyte.records.committed'], 5000);
    expect(a['airbyte.streams.count'], 8);
  });

  test('failed job sets span error', () async {
    await tracedAirbyte<String>(
      operation: 'connection.sync',
      invoke: () async => const AirbyteCallResult(
        value: 'ok',
        result: AirbyteResult(
          jobId: 99,
          jobStatus: 'failed',
        ),
      ),
    );
    expect(
      spans.findSpanByName('airbyte connection.sync')!.status,
      SpanStatusCode.Error,
    );
  });

  test('incomplete job sets span error', () async {
    await tracedAirbyte<String>(
      operation: 'connection.sync',
      invoke: () async => const AirbyteCallResult(
        value: 'ok',
        result: AirbyteResult(
          jobStatus: 'incomplete',
        ),
      ),
    );
    expect(
      spans.findSpanByName('airbyte connection.sync')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutAirbyteInstrumentationAsync(() async {
      await tracedAirbyte<String>(
        operation: 'workspaces.list',
        invoke: () async => const AirbyteCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('airbyte '), isEmpty);
  });
}
