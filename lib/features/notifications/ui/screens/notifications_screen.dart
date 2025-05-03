import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/core/services/navigation_service.dart';
import 'package:joblinc/core/theming/colors.dart';
import 'package:joblinc/features/notifications/data/models/notification_model.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_cubit.dart';
import 'package:joblinc/features/notifications/logic/cubit/notification_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  bool _hasMarkedAsRead = false; // Track if we've already marked notifications

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    debugPrint('NotificationsScreen: initState - Loading notifications');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Prevent keyboard from showing up automatically
      FocusManager.instance.primaryFocus?.unfocus();
    });
    // First fetch the notifications
    context.read<NotificationCubit>().getNotifications();

    // Ensure socket connection is active
    context.read<NotificationCubit>().initSocket();

    // Only mark notifications as read if this screen is intentionally shown
    // We'll determine this in didChangeDependencies
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   // Check if this is an active user navigation (not initial app load)
  //   // and we haven't already marked notifications as read
  //   if (!_hasMarkedAsRead && ModalRoute.of(context)?.isCurrent == true) {
  //     _hasMarkedAsRead = true;
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       context.read<NotificationCubit>().markAllAsSeen();
  //     });
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reconnect socket when app returns to foreground
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationCubit>().initSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listenWhen: (previous, current) {
          // Only trigger listener when we have a loaded state with notifications
          if (previous is NotificationLoaded && current is NotificationLoaded) {
            return current.notifications.length !=
                previous.notifications.length;
          }
          return previous.runtimeType != current.runtimeType;
        },
        listener: (context, state) {
          if (state is NotificationLoaded) {
            debugPrint(
                'NotificationsScreen: State updated with ${state.notifications.length} notifications');
            // Only scroll if we have a valid scroll controller and we're not already at the top
            if (_scrollController.hasClients &&
                _scrollController.position.pixels != 0) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Failed to load notifications',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14.sp, color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotificationCubit>().getNotifications();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<NotificationCubit>().getNotifications();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  return NotificationTile(
                    notification: state.notifications[index],
                    onTap: (id) {
                      context.read<NotificationCubit>().markAsRead(id);
                      NavigationService().notificationNavigator(
                        state.notifications[index],
                      );
                    },
                    isNew: index == 0 &&
                        state.notifications[index].isRead == "pending",
                  );
                },
              ),
            );
          }

          return const Center(child: Text('No notifications'));
        },
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final Function(String) onTap;
  final bool isNew;

  const NotificationTile({
    Key? key,
    required this.notification,
    required this.onTap,
    this.isNew = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(notification.toJson());
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      color: isNew
          ? ColorsManager.getPrimaryColor(context).withOpacity(0.1)
          : notification.isRead == "read"
              ? Colors.transparent
              : ColorsManager.getPrimaryColor(context).withOpacity(0.05),
      child: InkWell(
        onTap: () {
          context.read<NotificationCubit>().markAsRead(notification.id);
          NavigationService().notificationNavigator(
            notification,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 10.r,
                height: 10.r,
                margin: EdgeInsets.only(top: 8.h, right: 10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: notification.isRead == "read"
                      ? Colors.transparent
                      : ColorsManager.getPrimaryColor(context),
                ),
              ),
              _buildNotificationIcon(notification.type),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: notification.isRead == "read"
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      timeago.format(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    IconData iconData;
    Color iconColor;

    switch (type.toLowerCase()) {
      case 'connection':
        iconData = Icons.people;
        iconColor = Colors.blue;
        break;
      case 'job':
        iconData = Icons.work;
        iconColor = Colors.green;
        break;
      case 'message':
        iconData = Icons.message;
        iconColor = Colors.purple;
        break;
      case 'like':
        iconData = Icons.thumb_up;
        iconColor = Colors.orange;
        break;
      case 'comment':
        iconData = Icons.comment;
        iconColor = Colors.indigo;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20.r,
      ),
    );
  }
}
