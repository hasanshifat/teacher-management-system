import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tms/colors.dart';
import 'package:tms/components/myText.dart';
import 'package:tms/components/mytext3.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List option = [];
  List ques = [];
  Map<String, dynamic> map;
  var q;
  var an;
  Color color;
  Color rgt = Colors.green;
  Color wrg = Colors.red;
  int scr = 0;
  bool isSelected = false;
  List<QuestionItem> qlist = [];
  int docLenght = 0;
  Map<String, dynamic> data;

  Future getdata() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("test").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      data = querySnapshot.docs[i].data();
      // print(data.data());
      setState(() {
        qlist.add(QuestionItem(
            a: data['a'],
            b: data['b'],
            c: data['c'],
            d: data['d'],
            clrSelectedA: false,
            clrSelectedB: false,
            clrSelectedC: false,
            clrSelectedD: false,
            question: data['question'],
            right: data['right']));
      });
      // print(qlist[i].question);
    }
    setState(() {
      docLenght = querySnapshot.docs.length;
    });
    print(docLenght);
  }

  check(ans, val, index) {
    if (val == ans) {
      setState(() {
        scr++;
        color = Colors.green;
      });
    } else {
      setState(() {
        scr--;
        color = Colors.red;
      });
    }
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Mytext(
            text: 'Notice',
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Mytext(
                text: '$scr',
              ),
            )
          ],
        ),
        body: Container(
          height: size.height * 1,
          child: ListView.builder(
            itemCount: qlist.length,
            itemBuilder: (context, index) {
              docLenght = index + 1;
              if (qlist.length == 0) {
                return Center(child: CircularProgressIndicator());
              } else
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    color: kPrimaryColor1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListTile(
                          leading: Mytext(
                            text: '$docLenght',
                            color: kPrimaryColor4,
                          ),
                          title: Mytext3(
                            text: qlist[index].question,
                            fontsize: 20,
                          ),
                        ),
                        Card(
                          shape: StadiumBorder(),
                          color: qlist[index].clrSelectedA
                              ? Colors.green
                              : Colors.red,
                          child: ListTile(
                              onTap: () {
                                if (qlist[index].a == qlist[index].right) {
                                  print('object');
                                  setState(() {
                                    scr++;
                                    qlist[index].clrSelectedA = true;
                                  });
                                } else {
                                  setState(() {
                                    scr--;
                                    qlist[index].clrSelectedB = false;
                                    qlist[index].clrSelectedC = false;
                                    qlist[index].clrSelectedD = false;
                                  });
                                }
                              },
                              leading: CircleAvatar(
                                  backgroundColor: kPrimaryColor4,
                                  child: Center(
                                      child: Text('A',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)))),
                              title: Mytext3(
                                text: qlist[index].a,
                              )),
                        ),
                        Card(
                          shape: StadiumBorder(),
                          color: qlist[index].clrSelectedB
                              ? Colors.green
                              : Colors.white ?? Colors.red,
                          child: ListTile(
                              onTap: () {
                                if (qlist[index].b == qlist[index].right) {
                                  print('object');
                                  setState(() {
                                    scr++;
                                    qlist[index].clrSelectedB = true;
                                  });
                                } else {
                                  setState(() {
                                    scr--;
                                    qlist[index].clrSelectedA = false;
                                    qlist[index].clrSelectedC = false;
                                    qlist[index].clrSelectedD = false;
                                  });
                                }
                              },
                              leading: CircleAvatar(
                                  backgroundColor: kPrimaryColor4,
                                  child: Center(
                                      child: Text('B',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)))),
                              title: Mytext3(
                                text: qlist[index].b,
                              )),
                        ),
                        Card(
                          shape: StadiumBorder(),
                          color: qlist[index].clrSelectedC
                              ? Colors.green
                              : Colors.white,
                          child: ListTile(
                              onTap: () {
                                if (qlist[index].c == qlist[index].right) {
                                  print('object');
                                  setState(() {
                                    scr++;
                                    qlist[index].clrSelectedC = true;
                                  });
                                } else {
                                  setState(() {
                                    scr--;
                                    qlist[index].clrSelectedA = false;
                                    qlist[index].clrSelectedB = false;
                                    qlist[index].clrSelectedD = false;
                                  });
                                }
                              },
                              leading: CircleAvatar(
                                  backgroundColor: kPrimaryColor4,
                                  child: Center(
                                      child: Text('C',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)))),
                              title: Mytext3(
                                text: qlist[index].c,
                              )),
                        ),
                        Card(
                          shape: StadiumBorder(),
                          color: qlist[index].clrSelectedD
                              ? Colors.green
                              : Colors.white,
                          child: ListTile(
                              onTap: () {
                                if (qlist[index].d == qlist[index].right) {
                                  print('object');
                                  setState(() {
                                    scr++;
                                    qlist[index].clrSelectedD = true;
                                  });
                                } else {
                                  setState(() {
                                    scr--;
                                    qlist[index].clrSelectedA = false;
                                    qlist[index].clrSelectedB = false;
                                    qlist[index].clrSelectedC = false;
                                  });
                                }
                              },
                              leading: CircleAvatar(
                                  backgroundColor: kPrimaryColor4,
                                  child: Center(
                                      child: Text('D',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)))),
                              title: Mytext3(
                                text: qlist[index].d,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
            },
          ),
        ));
  }
}

class QuestionItem<T> {
  String a, b, c, d, question, right;
  bool clrSelectedA = false,
      clrSelectedB = false,
      clrSelectedC = false,
      clrSelectedD = false;
  T data;

  // QuestionItem(this.data);
  QuestionItem(
      {this.a,
      this.b,
      this.c,
      this.clrSelectedA,
      this.clrSelectedB,
      this.clrSelectedC,
      this.clrSelectedD,
      this.d,
      this.question,
      this.right});
}
