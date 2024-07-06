import 'package:KinesteX_B2B/export.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectIntegration = 0;
  List<IntegrationOption> options = generateOptions();
  List<String> subOption = generateOptions().first.subOption ?? <String>[];
  int selectSubOption = 0;
  String optionType = generateOptions().first.optionType;
  String title = generateOptions().first.title;

  String apiKey = "YOUR ACCESS KEY";
  String company = "YOUR COMPANY";
  String userId = "user1";

  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<String> mistake = ValueNotifier<String>("--");
  ValueNotifier<String?> updateExercise = ValueNotifier<String?>(null);

  @override

  /// Initializes the state of the widget.
  ///
  /// Calls the `super.initState()` method to initialize the state of the widget.
  /// Then, calls the `_checkCameraPermission()` method to check the camera
  /// permission.
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  /// Handles the web view message.
  ///
  /// Takes a [WebViewMessage] as a parameter.
  ///
  /// If the message is an [ExitKinestex], sets the value of [showKinesteX] to
  /// false.
  ///
  /// If the message is a [Reps], extracts the 'value' from the message data and
  /// sets the value of [reps] to it.
  ///
  /// If the message is a [Mistake], extracts the 'value' from the message data
  /// and sets the value of [mistake] to it.
  ///
  /// If the message is of any other type, logs the message data.
  ///
  /// Throws no exceptions.
  void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      // Handle ExitKinestex message
      setState(() {
        showKinesteX.value = false; // Need to remove State management
      });
    } else if (message is Reps) {
      final repsData = message.data['value'] as int?;
      if (repsData != null) {
        reps.value = repsData;
        log("Mistake message received with value: $repsData");
      }
    } else if (message is Mistake) {
      final mistakeData = message.data['value'] as String?;

      if (mistakeData != null) {
        mistake.value = mistakeData;
        log("Mistake message received with value: $mistakeData");
      }
    } else {
      // Handle other message types
      log("Other message received: ${message.data}");
    }
  }

  /// Checks the camera permission and shows a camera access denied alert if permission is not granted.
  void _checkCameraPermission() async {
    if (await Permission.camera.request() != PermissionStatus.granted) {
      if (mounted) {
        _showCameraAccessDeniedAlert(context);
      }
    }
  }

  /// Displays a dialog to inform the user that camera access is denied.
  ///
  /// The function takes a [BuildContext] as a parameter to access the current
  /// widget's context. It shows an [AlertDialog] with a title and content
  /// explaining the need for camera access. The dialog also includes an "OK"
  /// button that dismisses the dialog.
  ///
  /// Usage:
  ///
  /// ```dart
  /// _showCameraAccessDeniedAlert(context);
  /// ```
  void _showCameraAccessDeniedAlert(BuildContext context) {
    showDialog<dynamic>(
      context: context, // Now using the build context of the widget
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Permission Denied"),
          content: const Text("Camera access is required for this app to function properly."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop<Object?>(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  /// Builds the widget tree based on the current state of the widget.
  ///
  /// The `context` parameter is the current build context.
  ///
  /// Returns a `ValueListenableBuilder` widget that rebuilds whenever the
  /// value of `showKinesteX` changes.
  ///
  /// If `showKinesteX` is true, the `SafeArea` widget is returned with the
  /// `kinestexView` widget as its child.
  ///
  /// If `showKinesteX` is false, the `PopScope` widget is returned with the
  /// `Scaffold` widget as its child. The `Scaffold` widget has a black
  /// background color and a `Padding` widget as its body. The `Padding`
  /// widget has a padding of 16.0 on all sides and the `initialComponent`
  /// widget as its child.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKinesteX,
      builder: (
        BuildContext context,
        bool isshowKinesteX,
        Widget? child,
      ) {
        return isshowKinesteX
            ? SafeArea(
                child: Stack(
                  children: <Widget>[
                    kinestexView(), // Display the appropriate KinesteX view
                  ],
                ),
              )
            : PopScope<dynamic>(
                child: Scaffold(
                  backgroundColor: Colors.black,
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: initialComponent(),
                  ),
                ),
              );
      },
    );
  }

  /// Returns a widget that represents the initial component of the home screen.
  ///
  /// This function calculates the width and height of the screen and returns a
  /// Column widget with various child widgets. The Column widget is centered
  /// vertically and has a Spacer widget at the top. The first child of the
  /// Expandable widget is a Padding widget that contains a Container widget
  /// with a Text widget. The Text widget displays the text 'Select Integration
  /// Option' and has white color, font size of 18, and bold font weight. The
  /// second child of the Expandable widget is a Padding widget that contains
  /// a ListView.builder widget. The ListView.builder widget displays a list of
  /// radio buttons based on the length of the 'options' list. Each radio button
  /// is wrapped in a containerRadio widget. The containerRadio widget takes
  /// several parameters including the context, index, title, onTap, and onTap1.
  /// The onTap function updates the state of the widget and sets the
  /// 'selectIntegration', 'subOption', 'selectSubOption', 'optionType', and 'title'
  /// variables. The onTap1 function is similar to onTap but takes an additional
  /// parameter 'value'. The Expandable widget has various properties such as
  /// boxShadow, backgroundColor, borderRadius, centralizeFirstChild, and
  /// arrowWidget. The Expandable widget also has a second child that is similar
  /// to the first child but has a different text and a ListView.builder widget
  /// that displays a list of radio buttons based on the length of the 'subOption'
  /// list. The radio buttons are wrapped in a containerSubOption widget. The
  /// containerSubOption widget takes several parameters including the context,
  /// index, text, onTap, and onTap1. The onTap function updates the state of the
  /// widget and sets the 'selectSubOption' variable. The onTap1 function is similar
  /// to onTap but takes an additional parameter 'value'. The ElevatedButton
  /// widget is displayed at the bottom of the Column widget. It has a style
  /// property that sets the padding, background color, minimum size, shape, and
  /// text style. The onPressed property of the ElevatedButton widget sets the
  /// 'showKinesteX' value to true. The child of the ElevatedButton widget is a
  /// Text widget that displays the text 'View $title'.
  ///
  /// @return {Widget} The initial component of the home screen.
  Widget initialComponent() {
    double sizeWidth = MediaQuery.of(context).size.width / 100;
    double sizeHeight = MediaQuery.of(context).size.height / 100;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Spacer(),
        Expandable(
          firstChild: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16,
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                'Select Integration Option',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 5,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return containerRadio(
                  context,
                  index,
                  options[index].title,
                  () {
                    setState(() {
                      selectIntegration = index;
                      subOption = options[index].subOption!;
                      selectSubOption = 0;
                      optionType = options[index].optionType;
                      title = options[index].title;
                    });
                  },
                  (int? value) {
                    if (value != null) {
                      setState(() {
                        selectIntegration = value;
                        subOption = options[index].subOption!;
                        selectSubOption = 0;
                        optionType = options[index].optionType;
                        title = options[index].title;
                      });
                    }
                  },
                );
              },
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 48, 48, 48),
          borderRadius: BorderRadius.circular(12),
          centralizeFirstChild: true,
          arrowWidget: const Icon(
            CupertinoIcons.chevron_up,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: sizeHeight * 1),
        subOption.isEmpty
            ? const SizedBox.shrink()
            : Expandable(
                firstChild: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 16,
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select $optionType',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                secondChild: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: subOption.length,
                    itemBuilder: (BuildContext context, int index) {
                      return containerSubOption(
                        context,
                        index,
                        subOption[index],
                        () {
                          setState(() {
                            selectSubOption = index;
                          });
                        },
                        (int? value) {
                          setState(
                            () {
                              if (value != null) {
                                selectSubOption = index;
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                backgroundColor: const Color.fromARGB(255, 48, 48, 48),
                borderRadius: BorderRadius.circular(12),
                centralizeFirstChild: true,
                arrowWidget: const Icon(
                  CupertinoIcons.chevron_up,
                  color: Colors.grey,
                ),
              ),
        const Spacer(),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.green,
            minimumSize: Size(sizeWidth * 92, 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
          ),
          onPressed: () {
            showKinesteX.value = true;
          },
          child: Text(
            'View $title',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
          ),
        ),
      ],
    );
  }

  /// Returns a widget based on the selected integration.
  ///
  /// This function takes the value of `selectIntegration` and returns a widget
  /// based on the selected integration.
  ///
  /// Returns:
  /// - `createMainView()` if `selectIntegration` is equal to 0.
  /// - `createPlanView()` if `selectIntegration` is equal to 1.
  /// - `createWorkoutView()` if `selectIntegration` is equal to 2.
  /// - `createChallengeView()` if `selectIntegration` is equal to 3.
  /// - `createCameraComponent()` if `selectIntegration` is not equal to any of the
  ///   above cases.
  ///
  /// Throws:
  /// - None.
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
      default:
        return createCameraComponent();
    }
  }

  /// Returns the corresponding `PlanCategory` enum value based on the given category string.
  ///
  /// @param {String} category - The category string to be converted.
  /// @return {PlanCategory} The corresponding `PlanCategory` enum value.
  PlanCategory getPlanCategoryFromString(String category) {
    const Map<String, PlanCategory> categoryMap = <String, PlanCategory>{
      'cardio': PlanCategory.Cardio,
      'weightmanagement': PlanCategory.WeightManagement,
      'strength': PlanCategory.Strength,
      'rehabilitation': PlanCategory.Rehabilitation,
      'custom': PlanCategory.Custom,
    };
    return categoryMap[category.toLowerCase()] ?? PlanCategory.Cardio;
  }

  /// Creates a main view widget.
  ///
  /// Returns a [Center] widget with a [KinesteXAIFramework.createMainView] widget
  /// as its child.
  ///
  /// The [apiKey] is the API key used for the main view.
  /// The [companyName] is the company name used for the main view.
  /// The [isShowKinesTex] determines whether to show the KinesTex.
  /// The [userId] is the user ID used for the main view.
  /// The [planCategory] is the plan category used for the main view.
  /// The [isLoading] is a value notifier that determines whether the view is
  /// loading.
  /// The [onMessageReceived] is a callback function that handles the received
  /// web view message.
  ///
  /// Returns a [Widget] that represents the main view.
  Widget createMainView() {
    return Center(
      child: KinesteXAIFramework.createMainView(
        apiKey: apiKey,
        companyName: company,
        isShowKinesTex: showKinesteX,
        userId: userId,
        planCategory:
            getPlanCategoryFromString(options[selectIntegration].subOption![selectSubOption]),
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (WebViewMessage message) {
          handleWebViewMessage(message);
        },
      ),
    );
  }

  /// Creates a widget that displays a plan view.
  ///
  /// Returns a [Center] widget with a [KinesteXAIFramework.createPlanView] widget
  /// as its child.
  ///
  /// The [apiKey] is the API key used for the plan view.
  /// The [companyName] is the company name used for the plan view.
  /// The [userId] is the user ID used for the plan view.
  /// The [isShowKinesTex] determines whether to show the KinesTex.
  /// The [planName] is the name of the plan to display.
  /// The [isLoading] is a value notifier that determines whether the view is
  /// loading.
  /// The [onMessageReceived] is a callback function that handles the received
  /// web view message.
  ///
  /// Returns a [Widget] that represents the plan view.
  Widget createPlanView() {
    return Center(
      child: KinesteXAIFramework.createPlanView(
        apiKey: apiKey,
        companyName: company,
        userId: userId,
        isShowKinesTex: showKinesteX,
        planName: options[selectIntegration].subOption![selectSubOption],
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (WebViewMessage message) {
          handleWebViewMessage(message);
        },
      ),
    );
  }

  /// Creates a widget that displays a workout view.
  ///
  /// Returns a [Center] widget with a [KinesteXAIFramework.createWorkoutView]
  /// widget as its child.
  ///
  /// The [apiKey] is the API key used for the workout view.
  /// The [isShowKinesTex] determines whether to show the KinesTex.
  /// The [companyName] is the company name used for the workout view.
  /// The [userId] is the user ID used for the workout view.
  /// The [workoutName] is the name of the workout to display.
  /// The [isLoading] is a value notifier that determines whether the view is
  /// loading.
  /// The [onMessageReceived] is a callback function that handles the received
  /// web view message.
  ///
  /// Returns a [Widget] that represents the workout view.
  Widget createWorkoutView() {
    return Center(
      child: KinesteXAIFramework.createWorkoutView(
        apiKey: apiKey,
        isShowKinesTex: showKinesteX,
        companyName: company,
        userId: userId,
        workoutName: options[selectIntegration].subOption![selectSubOption],
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (WebViewMessage message) {
          handleWebViewMessage(message);
        },
      ),
    );
  }

  /// Returns a [Center] widget with a [KinesteXAIFramework.createChallengeView]
  /// widget as its child.
  ///
  /// The [apiKey] is the API key used for the challenge view.
  /// The [companyName] is the company name used for the challenge view.
  /// The [isShowKinesTex] determines whether to show the KinesTex.
  /// The [userId] is the user ID used for the challenge view.
  /// The [exercise] is the exercise to display.
  /// The [countdown] is the countdown time in seconds.
  /// The [isLoading] is a value notifier that determines whether the view is
  /// loading.
  /// The [onMessageReceived] is a callback function that handles the received
  /// web view message.
  ///
  /// Returns a [Widget] that represents the challenge view.
  Widget createChallengeView() {
    return Center(
      child: KinesteXAIFramework.createChallengeView(
        apiKey: apiKey,
        companyName: company,
        isShowKinesTex: showKinesteX,
        userId: userId,
        exercise: options[selectIntegration].subOption![selectSubOption],
        countdown: 100,
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (WebViewMessage message) {
          handleWebViewMessage(message);
        },
      ),
    );
  }

  /// Returns a [Stack] widget that contains a [KinesteXAIFramework.createCameraComponent]
  /// widget and a [Container] widget.
  ///
  /// The [KinesteXAIFramework.createCameraComponent] widget is created with the
  /// following parameters:
  /// - [apiKey]: The API key used for the camera component.
  /// - [companyName]: The company name used for the camera component.
  /// - [isShowKinesTex]: A value notifier that determines whether to show the KinesTex.
  /// - [userId]: The user ID used for the camera component.
  /// - [exercises]: A list of exercises to display.
  /// - [currentExercise]: The current exercise to display.
  /// - [updatedExercise]: The updated exercise to display.
  /// - [isLoading]: A value notifier that determines whether the camera component is
  ///   loading.
  /// - [onMessageReceived]: A callback function that handles the received web view message.
  ///
  /// The [Container] widget contains a [Column] widget with three children:
  /// - An [ElevatedButton] widget that updates the [updateExercise] value when pressed.
  /// - A [ValueListenableBuilder] widget that displays the number of reps.
  /// - A [ValueListenableBuilder] widget that displays the mistake.
  ///
  /// Returns a [Widget] that represents the camera component.
  Widget createCameraComponent() {
    return Stack(
      children: <Widget>[
        Center(
          child: ValueListenableBuilder<String?>(
            valueListenable: updateExercise,
            builder: (BuildContext context, String? value, Widget? _) {
              return KinesteXAIFramework.createCameraComponent(
                apiKey: apiKey,
                companyName: company,
                isShowKinesTex: showKinesteX,
                userId: userId,
                exercises: <String>["Squats", "Jumping Jack"],
                currentExercise: "Squats",
                updatedExercise: value,
                isLoading: ValueNotifier<bool>(false),
                onMessageReceived: (WebViewMessage message) {
                  handleWebViewMessage(message);
                },
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          // Set top margin of 20 pixels
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // Align children at the top of the column
            crossAxisAlignment: CrossAxisAlignment.center,
            // Center children horizontally
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    updateExercise.value = 'Jumping Jack';
                  },
                  child: const Text('Tap me')),
              ValueListenableBuilder<int>(
                valueListenable: reps,
                builder: (
                  BuildContext context,
                  int repsValue,
                  Widget? child,
                ) {
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
                builder: (
                  BuildContext context,
                  String mistakeValue,
                  Widget? child,
                ) {
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

  /// Creates a sized box with a radio button and a text label.
  ///
  /// @param {BuildContext} context - The context in which the sized box is being created.
  /// @param {int} selectIntegrationNum - The number of the selected integration.
  /// @param {String} text - The text to display next to the radio button.
  /// @param {VoidCallback} ontap - The function to call when the sized box is tapped.
  /// @param {Function(int?)?} onChanged - The function to call when the radio button is selected.
  /// @return {SizedBox} The sized box with the radio button and text label.
  SizedBox containerRadio(
    BuildContext context,
    int selectIntegrationNum,
    String text,
    VoidCallback ontap,
    Function(int?)? onChanged,
  ) {
    double sizeHeight = MediaQuery.of(context).size.height / 100;

    return SizedBox(
      height: sizeHeight * 6.5,
      child: InkWell(
        onTap: ontap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 1,
              child: Radio<int>(
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    return selectIntegrationNum != selectSubOption ? Colors.grey : Colors.green;
                  },
                ),
                focusColor: Colors.green,
                value: selectIntegrationNum,
                groupValue: selectIntegration,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a SizedBox widget with a height based on the device's screen height,
  /// containing an InkWell widget with a Row widget as its child. The Row widget
  /// contains a Text widget and a Radio widget. The Text widget displays the given
  /// text. The Radio widget is used for selecting an option. The appearance of
  /// the Radio widget changes based on the comparison of the selectIntegrationNum
  /// and selectSubOption. The onTap and ontap1 parameters are used as callbacks
  /// when the InkWell and Radio widgets are tapped respectively.
  ///
  /// @param {BuildContext} context - The current build context.
  /// @param {int} selectIntegrationNum - The selected integration number.
  /// @param {String} text - The text to be displayed.
  /// @param {VoidCallback} ontap - The callback function for the InkWell widget.
  /// @param {Function(int?)?} ontap1 - The callback function for the Radio widget.
  /// @return {SizedBox} The created SizedBox widget.
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
          children: <Widget>[
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Transform.scale(
              scale: 1,
              child: Radio<int>(
                fillColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
                  return selectIntegrationNum != selectSubOption ? Colors.grey : Colors.green;
                }),
                focusColor: Colors.green,
                value: selectIntegrationNum,
                groupValue: selectSubOption,
                onChanged: (int? value) {
                  setState(
                    () {
                      if (value != null) {
                        selectSubOption = value;
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Disposes the resources used by the object.
  ///
  /// This method is called when the object is no longer needed and is being
  /// removed from memory. It releases any resources that the object was using,
  /// such as memory or file handles.
  ///
  /// This method is typically called by the framework when the widget is
  /// removed from the widget tree.
  ///
  /// Subclasses should override this method to release any resources they
  /// are using. For example, if the object was using a database or a file,
  /// the subclass should close the connection or file.
  ///
  /// After the `dispose` method is called, the object is considered to be
  /// disposed and should not be used anymore.
  @override
  void dispose() {
    showKinesteX.dispose();
    reps.dispose();
    mistake.dispose();
    updateExercise.dispose();
    super.dispose();
  }
}
