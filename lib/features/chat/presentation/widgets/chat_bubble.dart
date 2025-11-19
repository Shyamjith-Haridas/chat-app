import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spaces.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.isCurrentUser,
    required this.message,
    required this.time,
  });

  final bool isCurrentUser;
  final String message;
  final String time;

  @override
  Widget build(BuildContext context) {
    final alignment = isCurrentUser
        ? Alignment.centerRight
        : Alignment.centerLeft;

    final bubbleBorderRadius = isCurrentUser
        ? BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          );

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: 280.w),
        margin: const EdgeInsets.only(
          top: AppSpaces.spaceBwInputs / 2,
          bottom: AppSpaces.spaceBwInputs / 2,
        ),
        padding: const EdgeInsets.all(AppSpaces.defaultSpacing),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.black87 : Colors.grey.shade300,
          borderRadius: bubbleBorderRadius,
        ),
        child: Column(
          spacing: AppSpaces.spaceBwItems,
          children: [
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: isCurrentUser ? AppColors.white : AppColors.black,
              ),
            ),
            Align(
              alignment: isCurrentUser
                  ? Alignment.centerRight
                  : Alignment.centerRight,
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isCurrentUser ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
