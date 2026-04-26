import 'package:flutter/material.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/knowledge.dart';
import 'package:oko_znaniy_mobile/services/knowledge_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/app_error.dart';
import 'package:intl/intl.dart';

class QuestionDetailScreen extends StatefulWidget {
  final int questionId;

  const QuestionDetailScreen({super.key, required this.questionId});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final KnowledgeService _service = KnowledgeService();
  KnowledgeQuestion? _question;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  Future<void> _loadQuestion() async {
    setState(() => _isLoading = true);
    try {
      _question = await _service.getQuestionDetail(widget.questionId);
      _error = null;
    } catch (e) {
      _error = 'Ошибка загрузки';
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вопрос')),
      body: _isLoading
          ? const AppLoading()
          : _error != null
              ? AppError(message: _error!, onRetry: _loadQuestion)
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _question!.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person_outline,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(_question!.authorName,
                              style: TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat('dd.MM.yyyy')
                                .format(_question!.createdAt),
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                      Text(_question!.content),
                      const SizedBox(height: 24),

                      Text(
                        'Ответы (${_question!.answersCount})',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),

                      // Placeholder for answers
                      if (_question!.answersCount == 0)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Пока нет ответов',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: answer question
        },
        child: const Icon(Icons.reply),
      ),
    );
  }
}
