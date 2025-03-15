import 'package:flutter/material.dart';

class JobDetailScreen extends StatelessWidget {
  final ScrollController scrollController;

  const JobDetailScreen({super.key, required this.scrollController,});
  
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.vertical(top:Radius.circular(20)),
      child: Container(
        decoration:BoxDecoration(
          color:Colors.white,
          
        ),
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          controller: scrollController,
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                "ETIC, Microsoft Dynamics F&O Functional Consultant - Manager",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8,),
              Text("PwC Middle East · Cairo, Cairo, Egypt · Reposted 1 week ago"),
              SizedBox(height: 8),
              Text("Over 100 people clicked apply"),
              SizedBox(height: 16),
              Row(
                children: [
                  Chip(label: Text("On-Site")),
                  SizedBox(width: 8,),
                  Chip(label: Text("Full-time")),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: Text("Apply")),
              OutlinedButton(onPressed: () {}, child: Text("Save")),
              SizedBox(height: 16),
              Text(
                "Use AI to assess how you fit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("Get AI-powered advice on this job and more exclusive features with Premium."),
            ],
          ),
        ),
      ),
    );
  }
}