import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/chat_provider.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/chat_input.dart';

class ChatbotScreen extends ConsumerWidget {
  const ChatbotScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatNotifierProvider);
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.smart_toy_rounded, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.aiAssistant,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      chatState.isLoading ? AppStrings.thinking : 'Ollama • gemma3:4b',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: chatState.isLoading
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => ref.read(chatNotifierProvider.notifier).clearChat(),
                icon: const Icon(Icons.delete_outline_rounded),
                tooltip: 'Limpiar chat',
              ),
            ],
          ),
        ),
        // Messages
        Expanded(
          child: chatState.messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 64, color: theme.colorScheme.outline),
                      const SizedBox(height: 16),
                      Text(
                        '¡Hola! Soy tu asistente IA del SENA',
                        style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pregúntame sobre formación, trámites o bienestar',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == chatState.messages.length && chatState.isLoading) {
                      return const ChatBubble(
                        content: '...',
                        isUser: false,
                        isLoading: true,
                      );
                    }
                    final message = chatState.messages[index];
                    return ChatBubble(
                      content: message.content,
                      isUser: message.isUser,
                    );
                  },
                ),
        ),
        // Input
        ChatInput(
          onSend: (message) => ref.read(chatNotifierProvider.notifier).sendMessage(message),
          isLoading: chatState.isLoading,
        ),
      ],
    );
  }
}
