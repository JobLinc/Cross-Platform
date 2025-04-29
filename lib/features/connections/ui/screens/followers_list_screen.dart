import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/connections/logic/cubit/connections_cubit.dart';
import 'package:joblinc/features/connections/logic/cubit/follow_cubit.dart';
import 'package:joblinc/features/connections/ui/widgets/follow_list_widget.dart';
import 'package:joblinc/features/userprofile/data/models/follow_model.dart';

class FollowersListScreen extends StatelessWidget {
  FollowersListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(412, 924),
      minTextAdapt: true,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              key: Key("followers_back_button"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Followers",
              style: TextStyle(fontSize: 20.sp),
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<FollowCubit, FollowState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is FollowInitial) {
                context.read<FollowCubit>().fetchFollowers();
                return const Center(child: CircularProgressIndicator());
              } else if (state is FollowLoaded) {
                return Column(
                  key: Key("FollowersListBody"),
                  children: [
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                      height: 0,
                    ),
                    Expanded(
                      child: FollowListView(
                        key: Key("followers_list"),
                        follows: state.follows,
                      ),
                    ),
                  ],
                );
              } else if (state is FollowError) {
                return Text(state.error);
              } else {
                return Text("nothing to show");
              }
            },
          ),
        );
      },
    );
  }
}
