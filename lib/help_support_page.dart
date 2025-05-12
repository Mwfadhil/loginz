import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': 'How do I create an account?',
      'answer': 'To create an account, go to the Sign Up page and enter your details.'
    },
    {
      'question': 'How can I reset my password?',
      'answer': 'Go to the Login screen and tap on "Forgot Password" to reset it via email.'
    },
    {
      'question': 'Is my data secure?',
      'answer': 'Yes, we use end-to-end encryption and secure cloud storage.'
    },
    {
      'question': 'How to use the dashboard?',
      'answer': 'The dashboard displays live data. You can tap on any widget for more details.'
    },
  ];

  final List<Map<String, String>> tutorials = [
    {
      'title': 'Getting Started with the App',
      'url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'
    },
    {
      'title': 'How to View Reports',
      'url': 'https://www.youtube.com/watch?v=Zi_XLOBDo_Y'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...faqs.map((faq) => ExpansionTile(
            title: Text(faq['question']!),
            children: [Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(faq['answer']!),
            )],
          )),

          SizedBox(height: 30),
          Text(
            'Contact Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text('Email Us'),
            subtitle: Text('muhdwasilatulfadhil@gmail.com'),
            onTap: () => _launchEmail('muhdwasilatulfadhil@gmail.com'),
          ),
          ListTile(
            leading: Icon(Icons.phone, color: Colors.green),
            title: Text('Call Us'),
            subtitle: Text('+601126134256'),
            onTap: () => _launchPhone('+601126134256'),
          ),

          SizedBox(height: 30),
          Text(
            'Video Tutorials',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...tutorials.map((video) => ListTile(
            leading: Icon(Icons.play_circle_fill, color: Colors.red),
            title: Text(video['title']!),
            trailing: Icon(Icons.open_in_new),
            onTap: () => _launchURL(video['url']!),
          )),
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(emailLaunchUri);
  }

  void _launchPhone(String phoneNumber) async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(phoneLaunchUri);
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
