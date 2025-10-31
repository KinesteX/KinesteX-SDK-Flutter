import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'option.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectIntegration = 0;
  List<IntegrationOption> options = generateOptions();
  List<String> subOption = generateOptions().first.subOption ?? [];
  int selectSubOption = 0;
  String optionType = generateOptions().first.optionType;
  String title = generateOptions().first.title;

  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<String> mistake = ValueNotifier<String>("--");
  ValueNotifier<String?> updateExercise = ValueNotifier<String?>(null);

  void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      // Handle ExitKinestex message
      setState(() {
        showKinesteX.value = false;
      });
    } else if (message is Reps) {
      setState(() {
        reps.value = message.data['value'] ?? 0;
      });
    } else if (message is Mistake) {
      setState(() {
        mistake.value = message.data['value'] ?? '--';
      });
    } else {
      // Handle other message types
      print("Other message received: ${message.data}");
    }
  }

  void _checkCameraPermission() async {
    if (await Permission.camera.request() != PermissionStatus.granted) {
      _showCameraAccessDeniedAlert(context);
    }
  }

  void _showCameraAccessDeniedAlert(BuildContext context) {
    showDialog(
      context: context, // Now using the build context of the widget
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Permission Denied"),
          content: const Text(
              "Camera access is required for this app to function properly."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKinesteX,
      builder: (context, isshowKinesteX, child) {
        return isshowKinesteX
            ? SafeArea(
                child: Stack(
                  children: [
                    kinestexView(), // Display the appropriate KinesteX view
                  ],
                ),
              )
            : Scaffold(
                backgroundColor: Colors.black,
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: initialComponent(),
                ),
              );
      },
    );
  }

  Widget initialComponent() {
    double sizeWidth = MediaQuery.of(context).size.width / 100;
    double sizeHeight = MediaQuery.of(context).size.height / 100;

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Spacer(),
      Expandable(
        firstChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
          child: Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Select Integration Option',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.only(left: 16, right: 5),
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (context, index) {
              return containerRadio(context, index, options[index].title, () {
                setState(() {
                  selectIntegration = index;
                  subOption = options[index].subOption!;
                  selectSubOption = 0;
                  optionType = options[index].optionType;
                  title = options[index].title;
                });
              }, (value) {
                setState(() {
                  selectIntegration = value!;
                  subOption = options[index].subOption!;
                  selectSubOption = 0;
                  optionType = options[index].optionType;
                  title = options[index].title;
                });
              });
            },
          ),
        ),
        boxShadow: const [],
        backgroundColor: const Color.fromARGB(255, 48, 48, 48),
        borderRadius: BorderRadius.circular(12),
        centralizeFirstChild: true,
        arrowWidget: const Icon(CupertinoIcons.chevron_up, color: Colors.grey),
      ),
      SizedBox(height: sizeHeight * 1),
      subOption.isEmpty
          ? const SizedBox()
          : Expandable(
              firstChild: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select $optionType',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              secondChild: Padding(
                padding: const EdgeInsets.only(left: 16, right: 5),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: subOption.length,
                  itemBuilder: (context, index) {
                    return containerSubOption(context, index, subOption[index],
                        () {
                      setState(() {
                        selectSubOption = index;
                      });
                    }, (value) {
                      setState(() {
                        selectSubOption = index;
                      });
                    });
                  },
                ),
              ),
              boxShadow: const [],
              backgroundColor: const Color.fromARGB(255, 48, 48, 48),
              borderRadius: BorderRadius.circular(12),
              centralizeFirstChild: true,
              arrowWidget:
                  const Icon(CupertinoIcons.chevron_up, color: Colors.grey),
            ),
      const Spacer(),
      ElevatedButton(
        child: Text(
          'View $title',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: Colors.green,
          minimumSize: Size(sizeWidth * 92, 0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
        ),
        onPressed: () {
          showKinesteX.value = true;
        },
      ),
    ]);
  }

  Widget kinestexView() {
    switch (selectIntegration) {
      case 0:
        return createMainView();
      case 1:
        return createPlanView();
      case 2:
        return createWorkoutView();
      case 3:
        return createChallengeView();
      case 4:
        return createExperienceView();
      case 5:
        return createLeaderboardView();
      case 6:
        return createPersonalizedPlanView();
      case 7:
        return createWorkoutEditorView();
      default:
        return createCameraComponent();
    }
  }

  PlanCategory getPlanCategoryFromString(String category) {
    switch (category.toLowerCase()) {
      case "cardio":
        return PlanCategory.Cardio;
      case "weightmanagement":
        return PlanCategory.WeightManagement;
      case "strength":
        return PlanCategory.Strength;
      case "rehabilitation":
        return PlanCategory.Rehabilitation;
      case "custom":
        return PlanCategory.Custom;
      default:
        return PlanCategory.Cardio;
    }
  }

  Widget createMainView() {
    return Center(
      child: KinesteXAIFramework.createMainView(
        isShowKinestex: showKinesteX,
        planCategory: getPlanCategoryFromString(
            options[selectIntegration].subOption![selectSubOption]),
        customParams: {
          "style": "dark", // light or dark theme (default is dark)
        },
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (message) {
          handleWebViewMessage(message);
        },
      ),
    );
  }

  Widget createPlanView() {
    return Center(
      child: KinesteXAIFramework.createPlanView(
          isShowKinestex: showKinesteX,
          planName: options[selectIntegration].subOption![selectSubOption],
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createWorkoutView() {
    return Center(
      child: KinesteXAIFramework.createWorkoutView(
          isShowKinestex: showKinesteX,
          workoutName: options[selectIntegration].subOption![selectSubOption],
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createChallengeView() {
    return Center(
      child: KinesteXAIFramework.createChallengeView(
          isShowKinestex: showKinesteX,
          exercise: "jz73VFlUyZ9nyd64OjRb",
          countdown: 100,
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createLeaderboardView() {
    return Center(
      child: KinesteXAIFramework.createLeaderboardView(
          isShowKinestex: showKinesteX,
          exercise: "Squats",
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createExperienceView() {
    return Center(
      child: KinesteXAIFramework.createExperienceView(
          isShowKinestex: showKinesteX,
          experience: "box",
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createPersonalizedPlanView() {
    return Center(
      child: KinesteXAIFramework.createPersonalizedPlanView(
          isShowKinestex: showKinesteX,
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createWorkoutEditorView() {
    return Center(
      child: KinesteXAIFramework.createAdminWorkoutEditor(
          organization: "your_organization_name",
          isShowKinestex: showKinesteX,
          customParams: {
            "style": "dark", // light or dark theme (default is dark)
          },
          isLoading: ValueNotifier<bool>(false),
          onMessageReceived: (message) {
            handleWebViewMessage(message);
          }),
    );
  }

  Widget createCameraComponent() {
    return Stack(
      children: [
        Center(
          child: ValueListenableBuilder<String?>(
              valueListenable: updateExercise,
              builder: (context, value, _) {
                return KinesteXAIFramework.createCameraComponent(
                  isShowKinestex: showKinesteX,
                  exercises: ["Squats", "Jumping Jack"],
                  currentExercise: "Squats",
                  customParams: {
                    "minPoseDetectionConfidence": 0.5,
                    "minTrackingConfidence": 0.8,
                    "minPosePresenceConfidence": 0.5,
                  },
                  updatedExercise: value,
                  isLoading: ValueNotifier<bool>(false),
                  onMessageReceived: (message) {
                    handleWebViewMessage(message);
                  },
                );
              }),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          // Set top margin of 20 pixels
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // Align children at the top of the column
            crossAxisAlignment: CrossAxisAlignment.center,
            // Center children horizontally
            children: [
              ElevatedButton(
                  onPressed: () {
                    updateExercise.value = 'Jumping Jack';
                  },
                  child: const Text('Tap me')),
              ValueListenableBuilder<int>(
                valueListenable: reps,
                builder: (context, repsValue, child) {
                  return Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      "REPS: $repsValue",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<String>(
                valueListenable: mistake,
                builder: (context, mistakeValue, child) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      "MISTAKE: $mistakeValue",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  SizedBox containerRadio(BuildContext context, int selectIntegrationNum,
      String text, VoidCallback ontap, Function(int?)? onChanged) {
    double sizeHeight = MediaQuery.of(context).size.height / 100;

    return SizedBox(
        height: sizeHeight * 6.5,
        child: InkWell(
            onTap: ontap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                      scale: 1,
                      child: Radio(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (selectIntegrationNum != selectIntegration) {
                              return Colors.grey;
                            }
                            return Colors.green;
                          }),
                          focusColor: Colors.green,
                          value: selectIntegrationNum,
                          groupValue: selectIntegration,
                          onChanged: onChanged)),
                ])));
  }

  SizedBox containerSubOption(
    BuildContext context,
    int selectIntegrationNum,
    String text,
    VoidCallback ontap,
    Function(int?)? ontap1,
  ) {
    double sizeHeight = MediaQuery.of(context).size.height / 100;

    return SizedBox(
        height: sizeHeight * 6.5,
        child: InkWell(
            onTap: ontap,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                      scale: 1,
                      child: Radio(
                          fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                            if (selectIntegrationNum != selectSubOption) {
                              return Colors.grey;
                            }
                            return Colors.green;
                          }),
                          focusColor: Colors.green,
                          value: selectIntegrationNum,
                          groupValue: selectSubOption,
                          onChanged: (value) {
                            setState(() {
                              selectSubOption = value!;
                            });
                          })),
                ])));
  }
}
