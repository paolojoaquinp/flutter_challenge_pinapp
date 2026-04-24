// HU-03: Recommendation Modal Widget.
// SRP: This widget is solely responsible for gathering and submitting a
//      movie recommendation. It owns the form and validation logic.
//      It is decoupled from MovieDetailPage so it can be reused or tested in isolation.
// AC3: Validates that the recipient field is not empty before submitting.
// AC4: Shows a SnackBar on successful submission.
import 'package:flutter/material.dart';

class RecommendationModalWidget extends StatefulWidget {
  final String movieTitle;

  const RecommendationModalWidget({
    super.key,
    required this.movieTitle,
  });

  /// Shows the recommendation modal as a bottom sheet.
  /// [context] must have a [Scaffold] ancestor for the success SnackBar.
  static Future<void> show(BuildContext context, {required String movieTitle}) {
    return showModalBottomSheet<void>(
      context: context,
      // AC-modal: isScrollControlled allows the sheet to grow with the keyboard.
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecommendationModalWidget(movieTitle: movieTitle),
    );
  }

  @override
  State<RecommendationModalWidget> createState() =>
      _RecommendationModalWidgetState();
}

class _RecommendationModalWidgetState extends State<RecommendationModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _recipientController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // AC3: Only proceeds if recipient field passes validation.
  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final recipient = _recipientController.text.trim();
    // In a real app, this would dispatch to a use-case / repository.
    // Here we close the modal and show the success snackbar (AC4).
    Navigator.of(context).pop();

    // AC4: SnackBar confirms the recommendation was sent.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recommendation for "${widget.movieTitle}" sent to $recipient!'),
        backgroundColor: const Color(0xFF1DB954),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Pad the bottom by the keyboard inset height to avoid overlap.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF444444),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Recommend to a friend',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"${widget.movieTitle}"',
              style: const TextStyle(
                color: Color(0xFFE50914),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),

            // Recipient field (required — AC3)
            _ModalTextField(
              controller: _recipientController,
              label: 'Recipient name or email',
              hint: 'e.g. john@example.com',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a recipient'; // AC3
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Optional personal note
            _ModalTextField(
              controller: _noteController,
              label: 'Personal note (optional)',
              hint: 'Why do you recommend this?',
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE50914),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Send Recommendation',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helper widget ─────────────────────────────────────────────────────

class _ModalTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;

  const _ModalTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFAAAAAA),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF555555)),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE50914), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.orangeAccent, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
