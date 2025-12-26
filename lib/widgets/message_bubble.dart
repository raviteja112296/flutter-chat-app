import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble.first({
    super.key,
    required this.userImage,
    required this.username,
    required this.message,
    required this.isMe,
  }) : isFirstInSequence = true;

  const MessageBubble.next({
    super.key,
    required this.message,
    required this.isMe,
  })  : isFirstInSequence = false,
        userImage = null,
        username = null;

  final bool isFirstInSequence;
  final String? userImage;
  final String? username;
  final String message;
  final bool isMe;

  static const _avatarSize = 36.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // LEFT AVATAR SPACE (always reserved)
          if (!isMe)
            SizedBox(
              width: _avatarSize,
              child: isFirstInSequence
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(userImage!),
                    )
                  : const SizedBox(),
            ),

          const SizedBox(width: 8),

          // MESSAGE BUBBLE
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: isMe
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft:
                      isMe ? const Radius.circular(14) : Radius.zero,
                  bottomRight:
                      isMe ? Radius.zero : const Radius.circular(14),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (isFirstInSequence && username != null)
                    Text(
                      username!,
                      style: theme.textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // RIGHT AVATAR SPACE (always reserved)
          if (isMe)
            SizedBox(
              width: _avatarSize,
              child: isFirstInSequence
                  ? CircleAvatar(
                      radius: 18,
                      backgroundImage: NetworkImage(userImage!),
                    )
                  : const SizedBox(),
            ),
        ],
      ),
    );
  }
}
