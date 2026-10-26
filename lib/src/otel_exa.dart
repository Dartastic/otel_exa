// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_exa_suppression.dart';

const _tracerName = 'dartastic_otel_libs_exa';

APITracer _tracer() => OTelAPI.tracerProvider().getTracer(_tracerName);

class ExaResult {
  /// Creates a result.
  const ExaResult({
    this.searchType,
    this.useAutoprompt,
    this.queryLength,
    this.numResults,
    this.resultCount,
    this.category,
    this.includeDomains,
    this.excludeDomains,
    this.startCrawlDate,
    this.endCrawlDate,
    this.startPublishedDate,
    this.endPublishedDate,
    this.includeText,
    this.excludeText,
    this.contentsTextMaxChars,
    this.contentsHighlights,
    this.contentsSummary,
    this.livecrawl,
    this.creditsUsed,
    this.errorCode,
    this.errorMessage,
    this.statusCode,
  });

  /// `auto`, `keyword`, `neural`, `magic`.
  final String? searchType;

  final bool? useAutoprompt;

  final int? queryLength;

  final int? numResults;
  final int? resultCount;

  /// `company`, `research paper`, `news`, `pdf`, `github`, `tweet`,
  /// `personal site`, `linkedin profile`, `financial report`.
  final String? category;

  final List<String>? includeDomains;
  final List<String>? excludeDomains;

  final String? startCrawlDate;
  final String? endCrawlDate;
  final String? startPublishedDate;
  final String? endPublishedDate;

  final String? includeText;
  final String? excludeText;

  /// `contents.text.maxCharacters` to limit response payload.
  final int? contentsTextMaxChars;
  final bool? contentsHighlights;
  final bool? contentsSummary;

  /// `always`, `fallback`, `never`.
  final String? livecrawl;

  /// Exa request credits.
  final int? creditsUsed;

  final String? errorCode;
  final String? errorMessage;
  final int? statusCode;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class ExaCallResult<T> {
  /// Creates a call result.
  const ExaCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final ExaResult? result;
}

/// Wraps an Exa API call in a CLIENT span. [operation] is one of
/// `search`, `findSimilar`, `contents`, `answer`, `getContents`,
/// `findSimilarAndContents`, `searchAndContents`.
Future<T> tracedExa<T>({
  required String operation,
  required Future<ExaCallResult<T>> Function() invoke,
}) async {
  if (exaInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'exa',
    'rpc.method': operation,
    'exa.operation': operation,
  };

  final span = _tracer().startSpan(
    'exa $operation',
    kind: SpanKind.client,
    attributes: OTelAPI.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final res = r.result!;
      final extras = <Attribute<Object>>[];
      if (res.searchType != null) {
        extras.add(OTelAPI.attributeString('exa.search_type', res.searchType!));
      }
      if (res.useAutoprompt != null) {
        extras.add(OTelAPI.attributeBool(
          'exa.use_autoprompt',
          res.useAutoprompt!,
        ));
      }
      if (res.queryLength != null) {
        extras.add(OTelAPI.attributeInt('exa.query.length', res.queryLength!));
      }
      if (res.numResults != null) {
        extras.add(OTelAPI.attributeInt('exa.num_results', res.numResults!));
      }
      if (res.resultCount != null) {
        extras.add(OTelAPI.attributeInt('exa.result.count', res.resultCount!));
      }
      if (res.category != null) {
        extras.add(OTelAPI.attributeString('exa.category', res.category!));
      }
      if (res.includeDomains != null) {
        extras.add(OTelAPI.attributeStringList(
          'exa.include_domains',
          res.includeDomains!,
        ));
      }
      if (res.excludeDomains != null) {
        extras.add(OTelAPI.attributeStringList(
          'exa.exclude_domains',
          res.excludeDomains!,
        ));
      }
      if (res.startCrawlDate != null) {
        extras.add(OTelAPI.attributeString(
          'exa.start_crawl_date',
          res.startCrawlDate!,
        ));
      }
      if (res.endCrawlDate != null) {
        extras.add(OTelAPI.attributeString(
          'exa.end_crawl_date',
          res.endCrawlDate!,
        ));
      }
      if (res.startPublishedDate != null) {
        extras.add(OTelAPI.attributeString(
          'exa.start_published_date',
          res.startPublishedDate!,
        ));
      }
      if (res.endPublishedDate != null) {
        extras.add(OTelAPI.attributeString(
          'exa.end_published_date',
          res.endPublishedDate!,
        ));
      }
      if (res.includeText != null) {
        extras.add(OTelAPI.attributeString(
          'exa.include_text',
          res.includeText!,
        ));
      }
      if (res.excludeText != null) {
        extras.add(OTelAPI.attributeString(
          'exa.exclude_text',
          res.excludeText!,
        ));
      }
      if (res.contentsTextMaxChars != null) {
        extras.add(OTelAPI.attributeInt(
          'exa.contents.text.max_chars',
          res.contentsTextMaxChars!,
        ));
      }
      if (res.contentsHighlights != null) {
        extras.add(OTelAPI.attributeBool(
          'exa.contents.highlights',
          res.contentsHighlights!,
        ));
      }
      if (res.contentsSummary != null) {
        extras.add(OTelAPI.attributeBool(
          'exa.contents.summary',
          res.contentsSummary!,
        ));
      }
      if (res.livecrawl != null) {
        extras.add(OTelAPI.attributeString('exa.livecrawl', res.livecrawl!));
      }
      if (res.creditsUsed != null) {
        extras.add(OTelAPI.attributeInt('exa.credits.used', res.creditsUsed!));
      }
      if (res.errorCode != null) {
        extras.add(OTelAPI.attributeString('exa.error.code', res.errorCode!));
        span.setStatus(SpanStatusCode.Error, 'Exa ${res.errorCode}');
      }
      if (res.errorMessage != null) {
        extras.add(OTelAPI.attributeString(
          'exa.error.message',
          res.errorMessage!,
        ));
      }
      if (res.statusCode != null) {
        extras.add(OTelAPI.attributeInt(
          'http.response.status_code',
          res.statusCode!,
        ));
        if (res.statusCode! >= 400) {
          span.setStatus(SpanStatusCode.Error, 'Exa HTTP ${res.statusCode}');
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTelAPI.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTelAPI.attributes([
      OTelAPI.attributeString(
        ErrorAttributes.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
