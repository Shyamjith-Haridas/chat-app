import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_spaces.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/features/chat/data/datasources/chat_services.dart';
import 'package:chat_app/features/chat/data/models/chat_message_model.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name, required this.receiverId});
  final String name;
  final String receiverId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _chatServices = ChatServices();
  final _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    _messageController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        title: Row(
          spacing: 12,
          children: [
            CircleAvatar(
              radius: 25.r,
              child: Text(Utils.getInitial(widget.name)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  "Online",
                  style: TextStyle(fontSize: 14.sp, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatMessageModel>>(
                stream: _chatServices.getMessages(
                  _currentUser.uid,
                  widget.receiverId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data ?? [];

                  if (messages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == _currentUser.uid;

                      return ChatBubble(
                        isCurrentUser: isMe,
                        message: message.text,
                        time: Utils.formatTimeStamp(message.timestamp),
                      );
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpaces.defaultPadding,
                    ),
                  );
                },
              ),
            ),

            // Message input
            Container(
              padding: const EdgeInsets.only(
                top: AppSpaces.spaceBwInputs,
                bottom: AppSpaces.spaceBwInputs,
              ),
              width: double.maxFinite,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpaces.defaultPadding,
                ),
                child: Row(
                  spacing: AppSpaces.defaultSpacing,
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: 5,
                        minLines: 1,
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "Write here..",
                        ),
                      ),
                    ),
                    IconButton.outlined(
                      onPressed: _sendMessage,
                      icon: const Icon(CupertinoIcons.arrow_right),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    await _chatServices.sendMessage(
      senderId: _currentUser.uid,
      receiverId: widget.receiverId,
      text: text,
    );

    _messageController.clear();
  }
}
