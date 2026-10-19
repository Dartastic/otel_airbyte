// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_airbyte/otel_airbyte.dart';

/// Traces Airbyte calls with OpenTelemetry.
///
/// `otel_airbyte` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Airbyte call in
/// [tracedAirbyte]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'airbyte-example');

  // Traces a Airbyte call.
  final airbyteId = await tracedAirbyte<String>(
    operation: 'create',
    invoke: () async {
      // Make the Airbyte call here, then report what it returned.
      const id = 'airbyte_8f3a2c';
      return const AirbyteCallResult(
          value: id,
          result: AirbyteResult(
              deployment: 'example',
              workspaceId: 'workspace_8f3a2c',
              sourceId: 'source_8f3a2c',
              sourceDefinition: 'example',
              sourceDockerImage: 'example',
              destinationId: 'destination_8f3a2c',
              destinationDefinition: 'example',
              destinationDockerImage: 'example',
              connectionId: 'connection_8f3a2c',
              connectionName: 'example',
              namespace: 'example',
              streamName: 'example',
              syncMode: 'example',
              jobId: 1,
              jobStatus: 'succeeded',
              attemptNumber: 1,
              recordsEmitted: 1,
              recordsCommitted: 1,
              bytesEmitted: 512,
              bytesCommitted: 512,
              streamsCount: 3,
              durationMs: 120,
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedAirbyte create returned $airbyteId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAirbyteInstrumentationAsync.
  await runWithoutAirbyteInstrumentationAsync(
    () => tracedAirbyte<String>(
      operation: 'create',
      invoke: () async {
        const id = 'airbyte_8f3a2c';
        return const AirbyteCallResult(
            value: id,
            result: AirbyteResult(
                deployment: 'example',
                workspaceId: 'workspace_8f3a2c',
                sourceId: 'source_8f3a2c',
                sourceDefinition: 'example',
                sourceDockerImage: 'example',
                destinationId: 'destination_8f3a2c',
                destinationDefinition: 'example',
                destinationDockerImage: 'example',
                connectionId: 'connection_8f3a2c',
                connectionName: 'example',
                namespace: 'example',
                streamName: 'example',
                syncMode: 'example',
                jobId: 1,
                jobStatus: 'succeeded',
                attemptNumber: 1,
                recordsEmitted: 1,
                recordsCommitted: 1,
                bytesEmitted: 512,
                bytesCommitted: 512,
                streamsCount: 3,
                durationMs: 120,
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
