import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/di/locator.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/features/chats/presentation/viewmodel/recent_chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatsScreen extends StatelessWidget {
  final String currentUserId;
  const ChatsScreen({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<RecentChatViewModel>(),
      builder: (context, _) {
        final viewModel = context.read<RecentChatViewModel>();
        return StreamBuilder(
          stream: viewModel.getUserChats(currentUserId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final chats = snapshot.data ?? [];
            if (chats.isEmpty) {
              return const Center(child: Text("No recent chats"));
            }

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                // Get the other userId
                final otherUserId = chat.userIds.firstWhere(
                  (id) => id != currentUserId,
                );

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const ListTile(title: Text("Loading..."));
                    }

                    final userData = userSnapshot.data!;
                    final userName = userData['name'] ?? 'Unknown';

                    return ListTile(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.chat,
                          arguments: {
                            'receiverId': otherUserId,
                            'name': userName, // fetch name if needed
                          },
                        );
                      },
                      leading: CircleAvatar(
                        radius: 30.r,
                        child: Text(Utils.getInitial(userName)),
                      ),
                      title: Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        chat.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.black87),
                      ),
                      trailing: Text(
                        Utils.formatTimeStamp(chat.lastMessageTime),
                        style: const TextStyle(color: AppColors.grey),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
