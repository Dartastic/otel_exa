// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_exa/otel_exa.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(serviceName: 'otel_exa-test');
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('searchAndContents records type + livecrawl + credits', () async {
    await tracedExa<String>(
      operation: 'searchAndContents',
      invoke: () async => const ExaCallResult(
        value: 'ok',
        result: ExaResult(
          searchType: 'neural',
          useAutoprompt: true,
          numResults: 10,
          resultCount: 10,
          category: 'research paper',
          contentsTextMaxChars: 2000,
          contentsHighlights: true,
          livecrawl: 'fallback',
          creditsUsed: 5,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('exa searchAndContents')!);
    expect(a['exa.search_type'], 'neural');
    expect(a['exa.category'], 'research paper');
    expect(a['exa.livecrawl'], 'fallback');
  });

  test('error code sets span error', () async {
    await tracedExa<String>(
      operation: 'search',
      invoke: () async => const ExaCallResult(
        value: 'ok',
        result: ExaResult(errorCode: 'rate_limited', statusCode: 429),
      ),
    );
    expect(
      spans.findSpanByName('exa search')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutExaInstrumentationAsync(() async {
      await tracedExa<String>(
        operation: 'findSimilar',
        invoke: () async => const ExaCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('exa '), isEmpty);
  });
}
