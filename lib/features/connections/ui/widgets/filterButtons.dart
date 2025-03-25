import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleChildScrollFilter extends StatelessWidget {
  const SingleChildScrollFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: Key("filter buttons "),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          IconButton(
            key: Key("connection_getallfilters_button"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(),
              );
            },
            icon: Icon(Icons.sort),
          ),
          ElevatedButton(
            key: Key("people filter button"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                70.w,
                MediaQuery.of(context).size.height / 30,
              ), // Match container height
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              backgroundColor: Color(0xff004c33),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  400,
                ), // Rounded corners
                side: BorderSide(
                  color: Colors.black, // Border color
                  width: 1, // Border thickness
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "People",
                  style: TextStyle(color: Colors.black),
                ),
                Icon(Icons.expand_more, color: Colors.black),
              ],
            ),
          ),
          SizedBox(
            height: 30.h,
            child: VerticalDivider(
              color: Colors.black,
              thickness: 1, // Adjust thickness for visibility
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 30, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  key: Key("1st filter button"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      side: BorderSide(
                        color: Colors.black, // Border color
                        width: 1, // Border thickness
                      ),
                    ),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      10.w,
                      MediaQuery.of(context).size.height / 30,
                    ), // Match height
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "1st",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  key: Key("2nd filter button"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: BorderSide(
                      color: Colors.black, // Border color
                      width: 1, // Border thickness
                    ),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      10.w,
                      MediaQuery.of(context).size.height / 30,
                    ), // Match height
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "2nd",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  key: Key("3rd+ filter button"),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      side: BorderSide(
                        color: Colors.black, // Border color
                        width: 1, // Border thickness
                      ),
                    ),
                    backgroundColor: Colors.white,
                    fixedSize: Size(
                      10.w,
                      MediaQuery.of(context).size.height / 30,
                    ), // Match height
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    "3rd+",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          ElevatedButton(
            key: Key("Locations filter button"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                90.w,
                MediaQuery.of(context).size.height / 30,
              ), // Match container height
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  400,
                ), // Rounded corners
                side: BorderSide(
                  color: Colors.black, // Border color
                  width: 1, // Border thickness
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Locations",
                  style: TextStyle(color: Colors.black),
                ),
                Icon(Icons.expand_more, color: Colors.black),
              ],
            ),
          ),
          VerticalDivider(),
          ElevatedButton(
            key: Key("Current Company filter button"),
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                120.w,
                MediaQuery.of(context).size.height / 30,
              ), // Match container height
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  400,
                ), // Rounded corners
                side: BorderSide(
                  color: Colors.black, // Border color
                  width: 1, // Border thickness
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Current Company",
                  style: TextStyle(color: Colors.black),
                ),
                Icon(Icons.expand_more, color: Colors.black),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
