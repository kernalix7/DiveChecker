// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Disclaimer Dialog
///
/// Shows important legal disclaimer on first app launch.
/// User must agree to continue using the app.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';

/// Key for storing disclaimer acceptance in SharedPreferences
const String _disclaimerAcceptedKey = 'disclaimer_accepted_v1';

/// Check if disclaimer has been accepted
Future<bool> isDisclaimerAccepted() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_disclaimerAcceptedKey) ?? false;
}

/// Mark disclaimer as accepted
Future<void> setDisclaimerAccepted() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_disclaimerAcceptedKey, true);
}

/// Show disclaimer dialog if not yet accepted
/// 
/// Returns true if user accepted, false otherwise.
/// Dialog is not dismissible - user must agree to continue.
Future<bool> showDisclaimerIfNeeded(BuildContext context) async {
  final accepted = await isDisclaimerAccepted();
  if (accepted) return true;
  
  if (!context.mounted) return false;
  
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const DisclaimerDialog(),
  );
  
  return result ?? false;
}

/// Disclaimer dialog widget
class DisclaimerDialog extends StatefulWidget {
  const DisclaimerDialog({super.key});

  @override
  State<DisclaimerDialog> createState() => _DisclaimerDialogState();
}

class _DisclaimerDialogState extends State<DisclaimerDialog> {
  bool _doNotShowAgain = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.colorScheme.error,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.disclaimerTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                l10n.disclaimerContent,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _doNotShowAgain,
              onChanged: (value) {
                setState(() {
                  _doNotShowAgain = value ?? true;
                });
              },
              title: Text(
                l10n.disclaimerDoNotShowAgain,
                style: theme.textTheme.bodyMedium,
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.icon(
          onPressed: () async {
            if (_doNotShowAgain) {
              await setDisclaimerAccepted();
            }
            if (context.mounted) {
              Navigator.of(context).pop(true);
            }
          },
          icon: const Icon(Icons.check),
          label: Text(l10n.disclaimerAgree),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
