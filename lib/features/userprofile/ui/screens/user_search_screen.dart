import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/widgets/profile_image.dart';
import 'package:joblinc/features/userprofile/logic/cubit/search_cubit.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  State<UserSearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchCubit>().search(query.trim());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search users...',
            border: InputBorder.none,
          ),
          onChanged: _onSearchChanged,
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(true),
            icon: Icon(Icons.arrow_back)),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Text('Search for users'));
          } else if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SearchLoaded) {
            final results = state.results;
            if (results.isEmpty) {
              return const Center(child: Text('No users found'));
            }
            return ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final user = results[index];
                return InkWell(
                  onTap: () async {
                    final auth = getIt<AuthService>();
                    final userId = await auth.getUserId();
                    if (userId == user.userId) {
                      Navigator.pushNamed(context, Routes.profileScreen);
                    } else {
                      Navigator.pushNamed(context, Routes.otherProfileScreen,
                          arguments: user.userId);
                    }
                  },
                  child: ListTile(
                    leading: ProfileImage(imageURL: user.profilePicture),
                    title: Text('${user.firstname} ${user.lastname}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.username),
                        Text(user.headline),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is SearchError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
