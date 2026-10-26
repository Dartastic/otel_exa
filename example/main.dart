// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_exa/otel_exa.dart';

/// Traces Exa calls with OpenTelemetry.
///
/// `otel_exa` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Exa call in
/// [tracedExa]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'exa-example');

  // Wraps an Exa API call in a CLIENT span.
  final exaId = await tracedExa<String>(
    operation: 'create',
    invoke: () async {
      // Make the Exa call here, then report what it returned.
      const id = 'exa_8f3a2c';
      return const ExaCallResult(
          value: id,
          result: ExaResult(
              searchType: 'auto',
              useAutoprompt: true,
              queryLength: 1,
              numResults: 1,
              resultCount: 3,
              category: 'company',
              includeDomains: ['example'],
              excludeDomains: ['example'],
              startCrawlDate: 'example',
              endCrawlDate: 'example',
              startPublishedDate: 'example',
              endPublishedDate: 'example',
              includeText: 'example',
              excludeText: 'example',
              contentsTextMaxChars: 1,
              contentsHighlights: true,
              contentsSummary: true,
              livecrawl: 'always',
              creditsUsed: 1,
              errorCode: 'example',
              errorMessage: 'example',
              statusCode: 201));
    },
  );
  OTelLog.info('tracedExa create returned $exaId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutExaInstrumentationAsync.
  await runWithoutExaInstrumentationAsync(
    () => tracedExa<String>(
      operation: 'create',
      invoke: () async {
        const id = 'exa_8f3a2c';
        return const ExaCallResult(
            value: id,
            result: ExaResult(
                searchType: 'auto',
                useAutoprompt: true,
                queryLength: 1,
                numResults: 1,
                resultCount: 3,
                category: 'company',
                includeDomains: ['example'],
                excludeDomains: ['example'],
                startCrawlDate: 'example',
                endCrawlDate: 'example',
                startPublishedDate: 'example',
                endPublishedDate: 'example',
                includeText: 'example',
                excludeText: 'example',
                contentsTextMaxChars: 1,
                contentsHighlights: true,
                contentsSummary: true,
                livecrawl: 'always',
                creditsUsed: 1,
                errorCode: 'example',
                errorMessage: 'example',
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
