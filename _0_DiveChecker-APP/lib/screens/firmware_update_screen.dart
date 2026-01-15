// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0.

/// Firmware Update Screen - OTA firmware update with signature verification
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/serial_provider.dart';
import '../security/firmware_verifier.dart';

class FirmwareUpdateScreen extends StatefulWidget {
  const FirmwareUpdateScreen({super.key});

  @override
  State<FirmwareUpdateScreen> createState() => _FirmwareUpdateScreenState();
}

class _FirmwareUpdateScreenState extends State<FirmwareUpdateScreen> {
  List<FileSystemEntity> _firmwareFiles = [];
  FirmwarePackage? _selectedPackage;
  bool _isLoading = false;
  bool _isVerifying = false;
  String? _errorMessage;
  String _searchPath = '';

  @override
  void initState() {
    super.initState();
    _initDefaultPath();
  }

  Future<void> _initDefaultPath() async {
    // Default to Downloads folder or Documents
    try {
      if (Platform.isLinux || Platform.isMacOS) {
        final home = Platform.environment['HOME'] ?? '';
        _searchPath = '$home/Downloads';
      } else if (Platform.isWindows) {
        final userProfile = Platform.environment['USERPROFILE'] ?? '';
        _searchPath = '$userProfile\\Downloads';
      } else {
        final dir = await getApplicationDocumentsDirectory();
        _searchPath = dir.path;
      }
      await _loadFirmwareFiles();
    } catch (e) {
      debugPrint('Error getting default path: $e');
    }
  }

  Future<void> _loadFirmwareFiles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final files = await FirmwareVerifier.listFirmwareFiles(_searchPath);
      setState(() {
        _firmwareFiles = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDirectory() async {
    final result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        _searchPath = result;
        _selectedPackage = null;
      });
      await _loadFirmwareFiles();
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['bin'],
    );
    
    if (result != null && result.files.single.path != null) {
      await _verifyFirmware(result.files.single.path!);
    }
  }

  Future<void> _verifyFirmware(String filePath) async {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final package = await FirmwareVerifier.verifyFirmwareFile(filePath);
      setState(() {
        _selectedPackage = package;
        _isVerifying = false;
      });
      
      // If valid, automatically extract the verified .uf2 for flashing
      if (package.isValid) {
        final extractedPath = await package.extractVerifiedFirmware(_searchPath);
        if (extractedPath != null) {
          _showSnackBar('Verified firmware saved: ${extractedPath.split('/').last}');
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isVerifying = false;
      });
    }
  }

  Future<void> _rebootToBootsel() async {
    final serial = context.read<SerialProvider>();
    if (!serial.isConnected) {
      _showSnackBar('Device not connected');
      return;
    }
    
    // Get the extracted .uf2 filename for the dialog
    String uf2FileName = 'the verified .uf2 file';
    if (_selectedPackage != null && _selectedPackage!.isValid) {
      final baseName = _selectedPackage!.fileName.replaceAll('_signed.bin', '').replaceAll('.bin', '');
      uf2FileName = '${baseName}_verified.uf2';
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(Icons.restart_alt, size: IconSizes.huge, color: ScoreColors.warning),
        title: const Text('Reboot to BOOTSEL'),
        content: Text(
          'The device will reboot into BOOTSEL mode for firmware update.\n\n'
          'After rebooting:\n'
          '1. A new drive "RPI-RP2" will appear\n'
          '2. Copy "$uf2FileName" to it\n'
          '3. Device will automatically restart\n\n'
          '⚠️ Only copy the _verified.uf2 file extracted by this app!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reboot'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      serial.sendCommand('B');  // Reboot to BOOTSEL command
      _showSnackBar('Reboot command sent');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.firmwareUpdate),
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _pickDirectory,
            tooltip: 'Change folder',
          ),
          IconButton(
            icon: const Icon(Icons.file_open),
            onPressed: _pickFile,
            tooltip: 'Select file',
          ),
        ],
      ),
      body: Column(
        children: [
          // Current path indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.md),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(Icons.folder, size: IconSizes.md, color: theme.colorScheme.primary),
                Spacing.horizontalSm,
                Expanded(
                  child: Text(
                    _searchPath,
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: _loadFirmwareFiles,
                  tooltip: 'Refresh',
                ),
              ],
            ),
          ),

          // File list or selected firmware info
          Expanded(
            child: _isVerifying
                ? const Center(child: CircularProgressIndicator())
                : _selectedPackage != null
                    ? _buildSelectedPackageInfo(theme)
                    : _buildFileList(theme, l10n),
          ),

          // Bottom action bar
          if (_selectedPackage != null)
            _buildActionBar(theme),
        ],
      ),
    );
  }

  Widget _buildFileList(ThemeData theme, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: IconSizes.display, color: theme.colorScheme.error),
            Spacing.verticalLg,
            Text(_errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      );
    }

    if (_firmwareFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off, size: IconSizes.display, color: StatusColors.disabled),
            Spacing.verticalLg,
            Text(
              'No firmware files found',
              style: TextStyle(fontSize: FontSizes.bodyLg, color: StatusColors.neutral),
            ),
            Spacing.verticalSm,
            Text(
              'Looking for *.bin or *_signed.bin files',
              style: TextStyle(fontSize: FontSizes.bodySm, color: StatusColors.disabled),
            ),
            Spacing.verticalXxl,
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.file_open),
              label: const Text('Select File'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(Spacing.md),
      itemCount: _firmwareFiles.length,
      itemBuilder: (context, index) {
        final file = _firmwareFiles[index];
        final fileName = file.path.split('/').last;
        final stat = File(file.path).statSync();
        final sizeKb = (stat.size / 1024).toStringAsFixed(1);
        final isSigned = fileName.contains('_signed');

        return Card(
          margin: const EdgeInsets.only(bottom: Spacing.sm),
          child: ListTile(
            leading: Icon(
              isSigned ? Icons.verified : Icons.description,
              color: isSigned ? ScoreColors.excellent : StatusColors.disabled,
            ),
            title: Text(fileName),
            subtitle: Text('$sizeKb KB • ${_formatDate(stat.modified)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _verifyFirmware(file.path),
          ),
        );
      },
    );
  }

  Widget _buildSelectedPackageInfo(ThemeData theme) {
    final package = _selectedPackage!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button
          TextButton.icon(
            onPressed: () => setState(() => _selectedPackage = null),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to file list'),
          ),
          const SizedBox(height: Spacing.lg),

          // Verification result card
          Card(
            color: package.isValid
                ? ScoreColors.excellent.withOpacity(Opacities.low)
                : ScoreColors.poor.withOpacity(Opacities.low),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xl),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: package.isValid
                          ? ScoreColors.excellent.withOpacity(Opacities.medium)
                          : ScoreColors.poor.withOpacity(Opacities.medium),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      package.isValid ? Icons.verified : Icons.gpp_bad,
                      size: IconSizes.huge,
                      color: package.isValid ? ScoreColors.excellent : ScoreColors.poor,
                    ),
                  ),
                  Spacing.horizontalXl,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          package.isValid
                              ? 'Signature Valid ✓'
                              : 'Signature Invalid ✗',
                          style: TextStyle(
                            fontSize: FontSizes.titleSm,
                            fontWeight: FontWeight.bold,
                            color: package.isValid ? ScoreColors.excellent : ScoreColors.poor,
                          ),
                        ),
                        if (package.errorMessage != null)
                          Text(
                            package.errorMessage!,
                            style: TextStyle(
                              fontSize: FontSizes.body,
                              color: ScoreColors.poorLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),

          // File info
          _buildInfoRow('File', package.fileName),
          _buildInfoRow('Firmware Size', package.firmwareSizeFormatted),
          _buildInfoRow('Signature Size', '${package.signatureSize} bytes'),
          if (package.firmwareHash.isNotEmpty)
            _buildInfoRow('SHA256', '${package.firmwareHash.substring(0, 16)}...'),
          
          const SizedBox(height: Spacing.xl),

          // Warning for invalid firmware
          if (!package.isValid)
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: ScoreColors.warning.withOpacity(Opacities.low),
                borderRadius: BorderRadii.mdAll,
                border: Border.all(color: ScoreColors.warning.withOpacity(Opacities.high)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: ScoreColors.warning),
                  Spacing.horizontalMd,
                  Expanded(
                    child: Text(
                      'This firmware is not signed with a valid key. '
                      'It may be corrupted or from an untrusted source.',
                      style: TextStyle(color: ScoreColors.goodLight),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: WidgetSizes.containerWide * 0.6,
            child: Text(
              label,
              style: TextStyle(
                fontSize: FontSizes.body,
                color: StatusColors.neutral,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: FontSizes.body),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(ThemeData theme) {
    final package = _selectedPackage!;
    final serial = context.watch<SerialProvider>();

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    package.fileName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    package.isValid ? 'Ready to install' : 'Verification failed',
                    style: TextStyle(
                      fontSize: FontSizes.bodySm,
                      color: package.isValid ? ScoreColors.excellent : ScoreColors.poor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: Spacing.md),
            FilledButton.icon(
              onPressed: package.isValid && serial.isConnected
                  ? _rebootToBootsel
                  : null,
              icon: const Icon(Icons.system_update),
              label: const Text('Install'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
