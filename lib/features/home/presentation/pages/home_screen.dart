import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_spaces.dart';
import 'package:chat_app/core/routes/route_names.dart';
import 'package:chat_app/features/auth/login/data/repositories/auth_repository.dart';
import 'package:chat_app/features/chats/presentation/pages/chats_screen.dart';
import 'package:chat_app/features/home/presentation/viewmodel/home_view_model.dart';
import 'package:chat_app/features/users/presentation/pages/users_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late HomeViewModel _homeViewModel;
  late AuthRepository _authRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _homeViewModel = GetIt.I<HomeViewModel>();
    _authRepository = GetIt.I();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _authRepository.currentUser?.uid ?? '';
    final currentUserName = _authRepository.currentUser?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpaces.defaultSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hi", style: TextStyle(color: AppColors.grey)),
              Text(
                currentUserName,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        leadingWidth: 100.w,
        title: Text(
          "ChatiFy",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _homeViewModel.logout().then((value) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteNames.login,
                  (route) => false,
                );
              });
            },
            icon: const Icon(CupertinoIcons.power),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Row(
                spacing: 12.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(CupertinoIcons.chat_bubble_2), Text("Chats")],
              ),
            ),
            Tab(
              child: Row(
                spacing: 12.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(CupertinoIcons.person_3), Text("Users")],
              ),
            ),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ChatsScreen(currentUserId: currentUserId),
          UsersScreen(currentUserId: currentUserId),
        ],
      ),
    );
  }
}
