import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/config/theme.dart';
import 'package:oko_znaniy_mobile/models/knowledge.dart';
import 'package:oko_znaniy_mobile/services/knowledge_service.dart';
import 'package:oko_znaniy_mobile/widgets/app_loading.dart';
import 'package:oko_znaniy_mobile/widgets/empty_state.dart';
import 'package:intl/intl.dart';

class KnowledgePortalScreen extends StatefulWidget {
  const KnowledgePortalScreen({super.key});

  @override
  State<KnowledgePortalScreen> createState() => _KnowledgePortalScreenState();
}

class _KnowledgePortalScreenState extends State<KnowledgePortalScreen> {
  final KnowledgeService _service = KnowledgeService();
  List<KnowledgeQuestion> _questions = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions({String? search}) async {
    setState(() => _isLoading = true);
    try {
      _questions = await _service.getQuestions(search: search);
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('База знаний')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: create question dialog
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Поиск вопросов...',
                prefixIcon: Icon(Icons.search),
              ),
              onSubmitted: (v) => _loadQuestions(search: v),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _loadQuestions(),
              child: _isLoading
                  ? const AppLoading()
                  : _questions.isEmpty
                      ? const EmptyState(
                          icon: Icons.help_outline,
                          title: 'Нет вопросов',
                          subtitle: 'Задайте первый вопрос!',
                        )
                      : ListView.builder(
                          itemCount: _questions.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            final q = _questions[index];
                            return Card(
                              child: InkWell(
                                onTap: () =>
                                    context.push('/knowledge/${q.id}'),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              q.title,
                                              style: const TextStyle(
                                                  fontWeight:
                                                      FontWeight.w600),
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (q.isSolved)
                                            const Icon(Icons.check_circle,
                                                color: AppColors.success,
                                                size: 20),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        q.content,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline,
                                              size: 14,
                                              color:
                                                  AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Text(q.authorName,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .textSecondary)),
                                          const SizedBox(width: 12),
                                          Icon(Icons.comment_outlined,
                                              size: 14,
                                              color:
                                                  AppColors.textSecondary),
                                          const SizedBox(width: 4),
                                          Text('${q.answersCount}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .textSecondary)),
                                          const Spacer(),
                                          Text(
                                            DateFormat('dd.MM.yyyy')
                                                .format(q.createdAt),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors
                                                    .textSecondary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
