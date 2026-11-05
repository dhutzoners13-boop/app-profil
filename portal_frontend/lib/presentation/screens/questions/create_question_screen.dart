import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portal_frontend/core/localization/app_localizations.dart';
import 'package:portal_frontend/core/localization/locale_provider.dart';
import 'package:portal_frontend/core/services/api_service.dart';
import 'package:portal_frontend/data/models/question_topic_model.dart';
import 'package:portal_frontend/presentation/widgets/error_view.dart';
import 'package:portal_frontend/presentation/widgets/loading_view.dart';

class CreateQuestionScreen extends StatefulWidget {
  const CreateQuestionScreen({super.key});

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  List<QuestionTopicModel> _topics = [];
  int? _selectedTopicId;

  bool _isLoadingTopics = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTopics();
  }

  Future<void> _loadTopics() async {
    final lang = context.read<LocaleProvider>().locale.languageCode;
    try {
      final list = await _apiService.getQuestionTopics(lang: lang);
      if (!mounted) return;
      setState(() {
        _topics = list;
        if (list.isNotEmpty) {
          _selectedTopicId = list.first.id;
        }
        _isLoadingTopics = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoadingTopics = false;
      });
    }
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);

    if (!_formKey.currentState!.validate()) return;
    if (_selectedTopicId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('validation_required'))),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final lang = context.read<LocaleProvider>().locale.languageCode;
    try {
      final payload = {
        'topic_id': _selectedTopicId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        'subject': _subjectController.text.trim(),
        'body': _bodyController.text.trim(),
      };

      await _apiService.createQuestion(payload, lang: lang);

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 48,
          ),
          title: Text(l10n.translate('success_submit_title')),
          content: Text(l10n.translate('success_submit_desc')),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.translate('ask_question')),
      ),
      body: _isLoadingTopics
          ? const LoadingView()
          : _errorMessage != null
              ? ErrorView(
                  message: _errorMessage,
                  onRetry: _loadTopics,
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translate('ask_question_title'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.translate('ask_question_subtitle'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Topic Dropdown
                        DropdownButtonFormField<int>(
                          initialValue: _selectedTopicId,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_topic'),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.category_outlined),
                          ),
                          items: _topics.map((t) {
                            return DropdownMenuItem<int>(
                              value: t.id,
                              child: Text(t.name),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedTopicId = val),
                          validator: (val) =>
                              val == null ? l10n.translate('validation_required') : null,
                        ),
                        const SizedBox(height: 16),

                        // Name
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_name'),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? l10n.translate('validation_required')
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_email'),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.translate('validation_required');
                            }
                            if (!val.contains('@') || !val.contains('.')) {
                              return l10n.translate('validation_email');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_phone'),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.phone_outlined),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subject
                        TextFormField(
                          controller: _subjectController,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_subject'),
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.subject_rounded),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty
                              ? l10n.translate('validation_required')
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Body
                        TextFormField(
                          controller: _bodyController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: l10n.translate('field_body'),
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(bottom: 70),
                              child: Icon(Icons.chat_outlined),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return l10n.translate('validation_required');
                            }
                            if (val.trim().length < 10) {
                              return l10n.translate('validation_min_length');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Submit Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton.icon(
                            onPressed: _isSubmitting ? null : _submit,
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.send_rounded),
                            label: Text(
                              _isSubmitting
                                  ? l10n.translate('btn_submitting')
                                  : l10n.translate('btn_submit'),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
