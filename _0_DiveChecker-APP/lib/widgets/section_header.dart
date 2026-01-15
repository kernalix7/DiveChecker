// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

library;

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  
  const SectionHeader(this.title, {super.key});
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(left: Spacing.xs),
      child: Text(
        title,
        style: TextStyle(
          fontSize: FontSizes.bodySm,
          fontWeight: FontWeight.bold,
          letterSpacing: LetterSpacings.widest,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}
