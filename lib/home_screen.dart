import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bmi_calculator/age_weight_widget.dart';
import 'package:flutter_bmi_calculator/gender_widget.dart';
import 'package:flutter_bmi_calculator/height_widget.dart';
import 'package:flutter_bmi_calculator/score_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 12,
            shape: const RoundedRectangleBorder(),
            child: Column(
              children: [
                GenderWidget(
                  onChange: (genderValue) {
                    gender = genderValue;
                  },
                ),
                HeightWidget(
                  onChange: (heightValue) {
                    _height = heightValue;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AgeWeightWidget(
                        onChange: (ageValue) {
                          _age = ageValue;
                        },
                        title: "Age",
                        max: 100,
                        min: 0,
                        initValue: 30),
                    AgeWeightWidget(
                        onChange: (weightValue) {
                          _weight = weightValue;
                        },
                        title: "Weight(Kg)",
                        max: 200,
                        min: 0,
                        initValue: 50),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  child: SwipeableButtonView(
                      isFinished: _isFinished,
                      onFinish: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                child:
                                    ScoreScreen(bmiScore: _bmiScore, age: _age),
                                type: PageTransitionType.fade));
                        setState(() {
                          _isFinished = false;
                        });
                      },
                      onWaitingProcess: () {
                        calculateBmi();
                        Future.delayed(const Duration(seconds: 1), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      activeColor: Colors.blue,
                      buttonWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                      buttonText: "CALCULATE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
