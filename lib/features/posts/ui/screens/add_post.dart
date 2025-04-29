import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';
import 'package:joblinc/core/widgets/loading_overlay.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_cubit.dart';
import 'package:joblinc/features/posts/logic/cubit/add_post_state.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});
  final TextEditingController _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPostCubit, AddPostState>(
      listener: (context, state) {
        if (state is AddPostStateLoading) {
        } else if (state is AddPostStateSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Post successful')));
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is AddPostStateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Error: ${state.error}",
            style: TextStyle(color: Colors.red),
          )));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: addPostTopBar(context, _inputController),
          body: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              right: 10.0,
              bottom: 20.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: LoadingIndicatorOverlay(
                    inAsyncCall: state is AddPostStateLoading,
                    child: TextField(
                      controller: _inputController,
                      maxLines: null,
                      expands: true,
                      onChanged: (text) => {if (text == '') {} else {}},
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(),
                      showCursor: true,
                      cursorColor: Colors.black,
                    ),
                  ),
                ),
                BottomButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}

class BottomButtons extends StatelessWidget {
  const BottomButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
            onPressed: () async {
              //TODO use the media
              final picker = ImagePicker();
              List<XFile> medias = await picker.pickMultipleMedia();
            },
            icon: Icon(Icons.image)),
        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      ],
    );
  }
}

AppBar addPostTopBar(
    BuildContext context, TextEditingController inputController) {
  return AppBar(
    title: GestureDetector(
      onTap: () {
        showModalBottomSheet(
            showDragHandle: true,
            context: context,
            builder: (context) {
              return PrivacySettings();
            });
      },
      child: Row(
        spacing: 8,
        children: [
          CircleAvatar(
            radius: 20,
          ),
          Text(
            "Anyone",
            style: TextStyle(fontSize: 20),
          ),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: inputController,
            builder: (context, value, child) {
              return TextButton(
                style: TextButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    textStyle: TextStyle(fontWeight: FontWeightHelper.semiBold),
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey),
                onPressed: value.text.isNotEmpty
                    ? () {
                        context.read<AddPostCubit>().addPost(value.text);
                      }
                    : null,
                child: Text('Post'),
              );
            }),
      )
    ],
  );
}

class PrivacySettings extends StatefulWidget {
  const PrivacySettings({super.key});

  @override
  State<PrivacySettings> createState() => PrivacySettingsState();
}

class PrivacySettingsState extends State<PrivacySettings> {
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = 1;
  }

  void _updateSelectedValue(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 5.0),
        child: Column(
          children: [
            Text(
              "Who can see your post?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeightHelper.bold,
              ),
            ),
            OverflowBar(
              children: [
                RadioListTile(
                    title: Text('public'),
                    subtitle: Text('data'),
                    value: 1,
                    groupValue: selectedValue,
                    onChanged: (value) => _updateSelectedValue),
                RadioListTile(
                    value: 2,
                    groupValue: selectedValue,
                    onChanged: (value) => _updateSelectedValue),
              ],
            )
          ],
        ),
      ),
    );
  }
}
