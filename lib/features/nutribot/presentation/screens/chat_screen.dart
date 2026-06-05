import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../providers/nutribot_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() { _ctrl.dispose(); _scroll.dispose(); super.dispose(); }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    context.read<NutribotProvider>().sendMessage(text);
    _ctrl.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent + 100, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Container(width: 44, height: 44, decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 24)),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('NutriBot', style: AppTypography.headlineMedium),
                  Text('Asisten nutrisi AI kamu', style: AppTypography.bodySmall),
                ]),
              ]),
            ),
            Divider(height: 1, color: AppColors.border),
            // Messages
            Expanded(
              child: Consumer<NutribotProvider>(
                builder: (_, bot, _) {
                  if (bot.messages.isEmpty) {
                    return Center(child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 80, height: 80, decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(20)), child: const Icon(Icons.smart_toy_rounded, size: 40, color: AppColors.primary)),
                        const SizedBox(height: 20),
                        Text('Tanya apa saja tentang nutrisi!', style: AppTypography.headlineSmall, textAlign: TextAlign.center),
                        const SizedBox(height: 8),
                        Text('NutriBot siap membantu kamu merencanakan pola makan sehat.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        Wrap(spacing: 8, runSpacing: 8, children: [
                          _SuggestionChip(text: 'Menu diet sehat', onTap: () { _ctrl.text = 'Berikan menu diet sehat untuk seminggu'; _send(); }),
                          _SuggestionChip(text: 'Kalori nasi goreng', onTap: () { _ctrl.text = 'Berapa kalori nasi goreng?'; _send(); }),
                          _SuggestionChip(text: 'Tips diet', onTap: () { _ctrl.text = 'Tips diet untuk pemula'; _send(); }),
                        ]),
                      ]),
                    ));
                  }
                  return ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(16),
                    itemCount: bot.messages.length + (bot.isLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == bot.messages.length) return _TypingIndicator();
                      final msg = bot.messages[i];
                      return _ChatBubble(text: msg['text'] as String, isUser: msg['isUser'] as bool);
                    },
                  );
                },
              ),
            ),
            // Input
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.border))),
              child: SafeArea(
                top: false,
                child: Row(children: [
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(hintText: 'Tanya NutriBot...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none), filled: true, fillColor: AppColors.surfaceLight, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(14)),
                    child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white), onPressed: _send),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _ChatBubble({required this.text, required this.isUser});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.surfaceCard,
          borderRadius: BorderRadius.only(topLeft: const Radius.circular(16), topRight: const Radius.circular(16), bottomLeft: Radius.circular(isUser ? 16 : 4), bottomRight: Radius.circular(isUser ? 4 : 16)),
          border: isUser ? null : Border.all(color: AppColors.border),
        ),
        child: isUser
            ? Text(text, style: AppTypography.bodyMedium.copyWith(color: Colors.white))
            : MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                  p: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                  strong: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  em: AppTypography.bodyMedium.copyWith(fontStyle: FontStyle.italic, color: AppColors.textPrimary),
                  listBullet: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                  h1: AppTypography.titleLarge.copyWith(color: AppColors.textPrimary),
                  h2: AppTypography.titleMedium.copyWith(color: AppColors.textPrimary),
                  h3: AppTypography.titleSmall.copyWith(color: AppColors.textPrimary),
                ),
              ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SuggestionChip({required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
        child: Text(text, style: AppTypography.labelSmall.copyWith(color: AppColors.primary)),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.surfaceCard, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
        child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) => Container(margin: EdgeInsets.only(right: i < 2 ? 4 : 0), width: 8, height: 8, decoration: BoxDecoration(color: AppColors.textTertiary.withValues(alpha: 0.5), shape: BoxShape.circle)))),
      ),
    );
  }
}
