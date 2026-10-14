import 'package:flutter/material.dart';

import 'language.dart';

/// Translates a UI label or local error key using this widget's current locale.
/// Unknown server messages and user content are displayed as received.
class LocalizedText extends StatelessWidget {
  const LocalizedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.softWrap,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool? softWrap;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) => Text(
        AppLocalizations.of(context).translate(text),
        style: style,
        textAlign: textAlign,
        softWrap: softWrap,
        maxLines: maxLines,
        overflow: overflow,
      );
}

String? localizedValidationMessage(BuildContext context, String? message) =>
    message == null
        ? null
        : AppLocalizations.of(context).translateValidationMessage(message);

class LocalizedValidationText extends StatelessWidget {
  const LocalizedValidationText(this.message, {super.key, this.style});
  final String message;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Text(
        AppLocalizations.of(context).translateValidationMessage(message),
        style: style ??
            Theme.of(context).inputDecorationTheme.errorStyle ??
            Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
      );
}
