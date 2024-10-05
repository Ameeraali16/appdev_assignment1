import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/info.dart';
import 'package:http/http.dart' as http;

class jobs extends StatelessWidget {
   jobs({super.key});

  final List<Job> jlist = [];

  //get jobs info
  Future getJobInfo() async{
    var response= await  http.get(Uri.parse('https://mpa0771a40ef48fcdfb7.free.beeceptor.com/jobs'));
    var jsonData = jsonDecode(response.body);

    for(var eachJob in jsonData['data']){
      final jobData = eachJob['job'];

      final j1 = Job(
        title: jobData['title'], // Access the title
        companyName: jobData['company']['name'], // Access the company name
        companyLogo: jobData['company']['logo'], // Access the company logo
        location: jobData['location']['name_en'], // Access the location in English
        jobType: jobData['type']['name_en'], // Access the job type in English
        timePosted: jobData['created_date'], // Access the time posted
      );
      jlist.add(j1);

    }
    print(jlist.length);
  }

  @override
  Widget build(BuildContext context) {
   
   return Scaffold(
    body: FutureBuilder(future: getJobInfo(), 
    builder:(context, snapshot) {
      //is it done loading
      if (snapshot.connectionState == ConnectionState.done) {
        return ListView.builder(
          itemCount: jlist.length,
          itemBuilder:(context,index) {
            final job = jlist[index];
            return ListTile(
               leading: Image.network(job.companyLogo, width: 50, height: 50), // Display company logo
                  title: Text(job.title), // Display job title
                  subtitle: Text(
                    '${job.companyName}\nLocation: ${job.location}\nType: ${job.jobType}\nPosted on: ${job.timePosted}',
                    style: TextStyle(color: Colors.black54),
                  )
            );
          }
          );
      } else {
          return Center(child: CircularProgressIndicator(),);
      }
    },),
    appBar: AppBar(
      title: const Text('Jobs'),
    ),
    bottomNavigationBar: BottomNavigationBar(items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
      label: 'Home'
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.person),
      label: 'Resume'
        ),
        BottomNavigationBarItem(
        icon: Icon(Icons.settings),
      label: 'Settings'
        ),
      
    ],),
   );
  }
}

