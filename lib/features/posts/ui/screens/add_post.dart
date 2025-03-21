import 'package:flutter/material.dart';
import 'package:joblinc/core/theming/font_weight_helper.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addPostTopBar(context),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          bottom: 20.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.image)),
                IconButton(onPressed: () {}, icon: Icon(Icons.add)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

AppBar addPostTopBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      onPressed: () => {Navigator.pop(context)},
      icon: Icon(Icons.arrow_back),
    ),
    title: GestureDetector(
      onTap: () {
        showPostSettings(context);
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
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              disabledBackgroundColor: Colors.grey.shade300,
              disabledForegroundColor: Colors.grey),
          onPressed: () {},
          child: Text('Post'),
        ),
      )
    ],
  );
}

Future<dynamic> showPostSettings(BuildContext context) {
  return showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (context) {
        return BottomSheet();
      });
}

class BottomSheet extends StatefulWidget {
  const BottomSheet({super.key});

  @override
  State<BottomSheet> createState() => BottomSheetState();
}

class BottomSheetState extends State<BottomSheet> {
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
