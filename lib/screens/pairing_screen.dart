import 'package:couple_timeline/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';

class PairingScreen extends StatefulWidget {
  final String myInviteCode;
  const PairingScreen({super.key, required this.myInviteCode});

  @override
  State<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends State<PairingScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  void _linkPartner() async {
    if (_codeController.text.trim().isEmpty) return;

    final code = _codeController.text.trim().toUpperCase();

    setState(() => _isLoading = true);

    try {
      await DatabaseService().linkPartner(code);
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        String errorMessage = e.toString();

        if (errorMessage.contains('Invalid invite code')) {
          errorMessage = l10n.errorLinkInvalid;
        } else if (errorMessage.contains('Cannot link with yourself')) {
          errorMessage = l10n.errorLinkSelf;
        } else if (errorMessage.contains('Partner is already linked')) {
          errorMessage = l10n.errorLinkAlreadyPaired;
        } else {
          errorMessage = errorMessage.replaceAll('Exception: ', '');
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.link_rounded, size: 80, color: Colors.grey),
            const SizedBox(height: 20),

            Text(
              l10n.pairingTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.pairingSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Section: My Invite Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Column(
                children: [
                  Text(l10n.myCodeLabel, style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.myInviteCode,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: widget.myInviteCode));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.codeCopiedMessage)));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Section: Code Input
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                labelText: l10n.enterPartnerCodeLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            const SizedBox(height: 20),

            FilledButton(
              onPressed: _isLoading ? null : _linkPartner,
              style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16)),
              child: _isLoading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.linkPartnerButton),
            ),
          ],
        ),
      ),
    );
  }
}
