import 'package:flutter/material.dart';
import 'package:patient_assistant_app/constants.dart';

// ignore: must_be_immutable
class DrugDetailScreen extends StatefulWidget {
  DrugDetailScreen({this.genericInfo, this.genericInteractions, this.title});
  final String title;
  final Map<String, dynamic> genericInfo;
  Map<String, dynamic> genericInteractions;

  @override
  _DrugDetailScreenState createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends State<DrugDetailScreen> {
  int interactionsNumber = 0;
  String interactions = '';
  bool allInstructions = false;
  final BoxDecoration headingDecoration = BoxDecoration(
    gradient: ksearchScreenGradient,
    borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
  );
  final TextStyle categoryStyle = TextStyle(fontSize: 23, color: kmainHeadingColor1, fontWeight: FontWeight.w300);
  final TextStyle headingStyle = TextStyle(fontSize: 23, color: Colors.white, fontFamily: 'Montserrat');
  final TextStyle descriptionStyle = TextStyle(fontSize: 17, letterSpacing: 0.2, height: 1.5, color: kdarkTextColor);
  final TextStyle descriptionHeading = TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600);

  removePattern() {
    String bullet = '\u2022';
    String instructions;
    if (widget.genericInfo['instructions'] != null) {
      instructions = widget.genericInfo['instructions'];
      setState(() {
        widget.genericInfo['instructions'] =
            instructions.replaceAll('<ul>', '').trim().replaceAll('</ul>', '').trim().replaceAll('<li>', '\n$bullet\t').replaceAll('</li>', '');
      });
    }
    if (widget.genericInfo['how_it_works'] != null) {
      String howItWorks = widget.genericInfo['how_it_works'];
      setState(() {
        widget.genericInfo['how_it_works'] = howItWorks.trim();
      });
    }
  }

  createInteractionsString({bool showAll}) {
    String temp = '';
    if (widget.genericInteractions != null) {
      List interactionsList = widget.genericInteractions['interactions'];
      interactionsNumber = interactionsList.length;
      if (interactionsList.length > 11) {
        if (showAll) {
          for (int i = 0; i < interactionsList.length; i++) {
            temp = temp + '${i + 1}.)\t${interactionsList[i]['description']}\n\n';
          }
          setState(() {
            interactions = temp.trim();
          });
        } else {
          for (int i = 0; i < 10; i++) {
            temp = temp + '${i + 1}.)\t${interactionsList[i]['description']}\n\n';
          }
          setState(() {
            interactions = temp.trim();
          });
        }
      } else if (interactionsList.length > 0) {
        for (int i = 0; i < interactionsList.length; i++) {
          temp = temp + '${i + 1}.)\t${interactionsList[i]['description']}\n\n';
        }
        setState(() {
          interactions = temp.trim();
        });
      } else {
        setState(() {
          interactions = null;
        });
      }
    } else {
      setState(() {
        interactions = null;
      });
    }
  }

  Widget showCategoryDetailDialog(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      contentPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 10),
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 25,
                          color: kappColor1,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                  child: Text(
                    'Category A',
                    style: descriptionHeading,
                  ),
                  decoration: headingDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '\tAdequate and well-controlled studies have failed to demonstrate a risk to the fetus/baby in the first trimester and there is no evidence of risk in later trimesters.\n',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: kdarkTextColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                  child: Text(
                    'Category B',
                    style: descriptionHeading,
                  ),
                  decoration: headingDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '\tAnimal reproduction studies have failed to demonstrate a risk to the fetus and there are no adequate and well-controlled studies in pregnant women.\n',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: kdarkTextColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                  child: Text(
                    'Category C',
                    style: descriptionHeading,
                  ),
                  decoration: headingDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '\tAnimal reproduction studies have shown an adverse effect on the fetus and there are no adequate and well-controlled studies in humans, but potential benefits may warrant use of the drug in pregnant women despite potential risks.\n',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: kdarkTextColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                  child: Text(
                    'Category D',
                    style: descriptionHeading,
                  ),
                  decoration: headingDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '\tThere is positive evidence of human fetal risk based on adverse reaction data from investigational or marketing experience or studies in humans, but potential benefits may warrant use of the drug in pregnant women despite potential risks.\n',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: kdarkTextColor),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 10),
                  child: Text(
                    'Category X',
                    style: descriptionHeading,
                  ),
                  decoration: headingDecoration,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Text(
                    '\tStudies in animals or humans have demonstrated fetal abnormalities and/or there is positive evidence of human fetal risk based on adverse reaction data from investigational or marketing experience, and the risks involved in use of the drug in pregnant women clearly outweigh potential benefits.\n',
                    style: TextStyle(fontSize: 16, letterSpacing: 0.2, height: 1.4, color: kdarkTextColor),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    if (widget.genericInteractions != null) {
      if (widget.title != widget.genericInteractions['generic']) {
        widget.genericInteractions = null;
      }
    }
    removePattern();
    createInteractionsString(showAll: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.vertical + 15, left: 15, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  child: Icon(Icons.keyboard_backspace, size: 25, color: kmainHeadingColor1),
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '${widget.title}',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: kmainHeadingColor1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Divider(
                    indent: 30,
                    endIndent: MediaQuery.of(context).size.width / 3.7,
                    thickness: 0.4,
                    color: Colors.grey.shade400,
                  ),
                  Center(
                      child: Text('Details',
                          style: TextStyle(
                            fontSize: 28,
                            color: kappColor1,
                            // fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w300,
                          ))),
                  Divider(
                    indent: MediaQuery.of(context).size.width / 3.7,
                    thickness: 0.4,
                    color: Colors.grey.shade400,
                    endIndent: 30,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                          decoration: headingDecoration,
                          child: Text('Pregnancy Category:', style: headingStyle),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(left: 5),
                          constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                          icon: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: kappColor1,
                          ),
                          onPressed: () {
                            showDialog(context: context, builder: (context) => showCategoryDetailDialog(context));
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Text('\"${widget.genericInfo['pregnancy_category'] ?? '\"NA\"'}\"', style: categoryStyle),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                          decoration: headingDecoration,
                          child: Text('Lactation Category:', style: headingStyle),
                        ),
                        IconButton(
                          padding: EdgeInsets.only(left: 5),
                          constraints: BoxConstraints(maxHeight: 30, maxWidth: 30),
                          icon: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: kappColor1,
                          ),
                          onPressed: () {
                            showDialog(context: context, builder: (context) => showCategoryDetailDialog(context));
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(
                        '\"${widget.genericInfo['lactation_category'] ?? '\"NA\"'}\"',
                        style: categoryStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 0.4,
                color: Colors.grey.shade400,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                decoration: headingDecoration,
                child: Text(
                  'Used For:',
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.genericInfo['used_for'] ?? '\"NA\"',
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 0.4,
                color: Colors.grey.shade400,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                decoration: headingDecoration,
                child: Text(
                  'Instructions:',
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.genericInfo['instructions'] ?? '\"NA\"',
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 0.4,
                color: Colors.grey.shade400,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                decoration: headingDecoration,
                child: Text(
                  'How it Works:',
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.genericInfo['how_it_works'] ?? '\"NA\"',
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 30,
                endIndent: 30,
                thickness: 0.4,
                color: Colors.grey.shade400,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                decoration: headingDecoration,
                child: Text(
                  'Side Effects:',
                  style: headingStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.genericInfo['side_effects'] ?? '\"NA\"',
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                indent: 30,
                endIndent: 30,
                color: Colors.grey.shade400,
                thickness: 0.4,
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      padding: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 10),
                      decoration: headingDecoration,
                      child: Text(
                        'Drug Interactions:',
                        style: headingStyle,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      child: Text(
                        'Total $interactionsNumber found',
                        style: TextStyle(color: Colors.black45, fontWeight: FontWeight.w600),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xfffad0c4), Color(0xffffd1ff)]),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  interactions ?? '\"NA\"',
                  style: descriptionStyle,
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Visibility(
                  visible: widget.genericInteractions != null && interactionsNumber > 11,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.genericInteractions != null) {
                        setState(() {
                          allInstructions = !allInstructions;
                        });
                        createInteractionsString(showAll: allInstructions);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 35,
                      width: 100,
                      child: Center(child: Text(allInstructions ? 'Show Less' : 'Show All', style: TextStyle(color: Colors.white, fontSize: 18))),
                      decoration: kSelectedFormDecoration.copyWith(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
