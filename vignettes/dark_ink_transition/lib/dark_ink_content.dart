import 'package:flutter/material.dart';

import 'main.dart';

class DarkInkContent extends StatelessWidget {
  static const String headerText = 'The Private History of a Campaign That Failed';
  static const String subHeaderText = '5 minute read';
  static const String bodyText =
      'You have heard from a great many people who did something in the war, is it not fair and right that you listen a little moment to one who started out to do something in it but didn\'t? Thousands entered the war, got just a taste of it, and then stepped out again permanently.\n\nThese, by their very numbers, are respectable and therefore entitled to a sort of voice, not a loud one, but a modest one, not a boastful one but an apologetic one. They ought not be allowed much space among better people, people who did something. I grant that, but they ought at least be allowed to state why they didn\'t do anything and also to explain the process by which they didn\'t do anything. Surely this kind of light must have some sort of value.\n\nOut west there was a good deal of confusion in men\'s minds during the first months of the great trouble, a good deal of unsettledness, of leaning first this way then that, and then the other way. It was hard for us to get our bearings. I call to mind an example of this. I was piloting on the Mississippi when the news came that South Carolina had gone out of the Union on the 20th of December, 1860. My pilot mate was a New Yorker. He was strong for the Union; so was I. But he would not listen to me with any patience, my loyalty was smirched, to his eye, because my father had owned slaves. I said in palliation of this dark fact that I had heard my father say, some years before he died, that slavery was a great wrong and he would free the solitary Negro he then owned if he could think it right to give away the property of the family when he was so straitened in means. My mate retorted that a mere impulse was nothing, anyone could pretend to a good impulse, and went on decrying my Unionism and libelling my ancestry. A month later the secession atmosphere had considerably thickened on the Lower Mississippi and I became a rebel; so did he. We were together in New Orleans the 26th of January, when Louisiana went out of the Union. He did his fair share of the rebel shouting but was opposed to letting me do mine. He said I came of bad stock, of a father who had been willing to set slaves free. In the following summer he was piloting a Union gunboat and shouting for the Union again and I was in the Confederate army. I held his note for some borrowed money. He was one of the most upright men I ever knew but he repudiated that note without hesitation because I was a rebel and the son of a man who owned slaves. ';

  final bool darkMode;
  final ScrollController scrollController;

  DarkInkContent({this.darkMode, this.scrollController});

  @override
  Widget build(context) {
    final lightTextColor = Color(0xFFBCFEEA);
    final darkTextColor = Color(0xFF210A3B);
    final lightSubHeaderColor = Color(0xFF00EBAC);
    final darkSubHeaderColor = Color(0xFF008F9C);
    // Build a simple scroll view that just displays content with the passed scroll controller
    return SingleChildScrollView(
      controller: scrollController,
      scrollDirection: Axis.vertical,
      child: Container(
        color: darkMode ? Color(0xFF313466) : Color(0xFFFFFFFF),
        padding: EdgeInsets.all(37),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            headerText,
            style: TextStyle(
                fontSize: 36,
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.bold,
                color: darkMode ? lightTextColor : darkTextColor,
                decoration: TextDecoration.none,
                package: App.pkg),
          ),
          Padding(padding: EdgeInsets.only(top: 24)),
          Text(
            subHeaderText,
            style: TextStyle(
                fontSize: 12,
                fontFamily: 'Merriweather',
                color: darkMode ? lightSubHeaderColor : darkSubHeaderColor,
                decoration: TextDecoration.none,
                package: App.pkg),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          Container(
            height: 1,
            color: darkMode ? Color(0x510098A3) : Color(0x512B777E),
          ),
          Padding(padding: EdgeInsets.only(top: 24)),
          Text(
            bodyText,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Barlow',
                letterSpacing: 0.5,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: darkMode ? lightTextColor : darkTextColor,
                decoration: TextDecoration.none,
                package: App.pkg),
          ),
          Padding(padding: EdgeInsets.only(top: 64)),
        ]),
      ),
    );
  }
}
