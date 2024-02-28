import 'dart:math';

class Email {
  final String from;
  final String subject;
  final String body;
  bool isRead;
  bool isFavorite;

  int randNum = Random().nextInt(999);

  Email({required this.from, required this.subject, required this.body, this.isRead = false, this.isFavorite = false});

  toggleFavorite() {
    this.isFavorite = !this.isFavorite;
  }
}

class DemoData {
  final List<Email> _inbox = [
    Email(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Jeffrey Evans',
      subject: 'Re: Workshop Preperation',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Jordan Chow',
      isRead: true,
      subject: 'Reservation Confirmed for Brooklyn',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Katherine Woodward',
      subject: 'Rough outline',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Maddie Toohey',
      isRead: true,
      subject: 'Daily Recap for Tuesday, October 30',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Tamia Clouthier',
      isRead: true,
      subject: 'Workshop Information',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Daniel Song',
      subject: 'Possible Urgent Absence',
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
    Email(
      from: 'Andrew Argue',
      subject: 'Vacation Request',
      isRead: true,
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum at viverra sem. Suspendisse gravida magna in lorem vehicula…',
    ),
  ];

  int getIndexOf(Email email) {
    return _inbox.indexWhere((Email inbox) => inbox.subject == email.subject);
  }

  List<Email> getData() {
    return _inbox;
  }
}
