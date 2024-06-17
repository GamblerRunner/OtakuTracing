import 'package:flutter/material.dart';

void main() {
  runApp(HelpApp());
}

class HelpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HelpPage(),
    );
  }
}

class HelpPage extends StatelessWidget {
  final String termsAndConditions = '''
Terms of Use and Conditions

Effective Date: 17/08/2024

Welcome to OtakuTracing! These Terms of Use and Conditions ("Terms") govern your use of the OtakuTracing application ("App") provided by [Your Company Name] ("Company," "we," "us," or "our"). By accessing or using the App, you agree to be bound by these Terms. If you do not agree with these Terms, please do not use the App.

1. Use of the App

1.1 Eligibility: You must be at least 13 years old to use the App. By using the App, you represent and warrant that you meet this eligibility requirement.

1.2 Account Registration: To access certain features of the App, you may need to create an account. You agree to provide accurate, current, and complete information during the registration process and to update such information to keep it accurate, current, and complete.

1.3 Account Security: You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.

2. User Conduct

2.1 Prohibited Activities: You agree not to use the App for any unlawful or prohibited purpose. You shall not:

Violate any applicable laws or regulations.
Post, upload, or distribute any content that is unlawful, defamatory, obscene, or otherwise objectionable.
Use the App to harass, threaten, or intimidate others.
Interfere with or disrupt the App or its servers or networks.
2.2 User Content: You retain ownership of any content you post, upload, or share on the App ("User Content"). However, by posting User Content, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, and distribute your User Content for the purpose of operating and improving the App.

3. Intellectual Property

3.1 Ownership: The App and its content, including but not limited to text, graphics, logos, and software, are the property of the Company or its licensors and are protected by intellectual property laws.

3.2 License: We grant you a limited, non-exclusive, non-transferable license to access and use the App for your personal, non-commercial use.

4. Privacy

Your use of the App is also governed by our Privacy Policy, which can be found at [Privacy Policy URL]. By using the App, you consent to the collection, use, and sharing of your information as described in the Privacy Policy.

5. Disclaimers and Limitation of Liability

5.1 Disclaimers: The App is provided "as is" and "as available" without warranties of any kind, either express or implied. We do not warrant that the App will be uninterrupted, error-free, or secure.

5.2 Limitation of Liability: To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the App.

6. Indemnification

You agree to indemnify and hold us harmless from any claims, losses, liabilities, damages, and expenses (including reasonable attorneys' fees) arising out of or in connection with your use of the App or your violation of these Terms.

7. Termination

We may terminate or suspend your access to the App at any time, without prior notice or liability, for any reason, including if you breach these Terms.

8. Changes to these Terms

We may update these Terms from time to time. We will notify you of any changes by posting the new Terms on the App. Your continued use of the App after the changes take effect constitutes your acceptance of the revised Terms.

9. Governing Law

These Terms are governed by and construed in accordance with the laws of Spain, without regard to its conflict of law principles.

10. Contact Us

If you have any questions or concerns about these Terms, please contact us at OtakuTracing@gmail.com.
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color :Colors.white),
        title: Text(
          'TERMS AND CONDITIONS \n                OF USE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          termsAndConditions,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
