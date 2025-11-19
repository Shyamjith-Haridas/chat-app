import 'package:chat_app/core/constants/app_spaces.dart';
import 'package:chat_app/core/di/locator.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/features/auth/signup/data/repositories/user_repository.dart';
import 'package:chat_app/features/users/presentation/viewmodel/users_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key, required this.currentUserId});

  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final vmodel = UsersViewModel(getIt<UserRepository>());
        vmodel.loadAllUsers(currentUserId);
        return vmodel;
      },
      child: Consumer<UsersViewModel>(
        builder: (context, vm, _) {
          if (vm.usersStream == null) {
            return const Center(child: Text("User stream is null"));
          }

          return StreamBuilder(
            stream: vm.usersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No users available"));
              }

              final users = snapshot.data!;

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];

                  return Padding(
                    padding: EdgeInsets.only(top: AppSpaces.spaceBwItems.h),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.chat,
                          arguments: {
                            'name': user.name,
                            'receiverId': user.uid,
                          },
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.r,
                          child: Text(Utils.getInitial(user.name)),
                        ),
                        title: Text(
                          user.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
