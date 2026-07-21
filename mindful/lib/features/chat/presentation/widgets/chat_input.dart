import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController? controller;
  final VoidCallback? onSend;

  const ChatInput({
    super.key,
    this.controller,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: "Ask Echo anything...",
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: .55),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Material(
                color: AppTheme.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onSend,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 48,
                    height: 48,
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
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