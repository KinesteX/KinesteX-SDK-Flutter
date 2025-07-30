# KinesteX Motion Recognition: Real-Time User Engagement

### **Enhance Your App with Motion Tracking**
Integrate our advanced motion recognition camera component to deliver an interactive and immersive fitness experience. 

### **Key Features**
- **Real-Time Feedback:**  
  Provide instant feedback based on user movements, including:
  - Counting repetitions
  - Identifying mistakes
  - Calculating calories burned  
  All results are seamlessly displayed in your app's user interface.

- **Boost User Engagement:**  
  Keep users motivated with detailed and interactive exercise feedback, ensuring a more engaging workout experience.

- **Customizable Integration:**  
  Fully control the position, size, and placement of the camera component to create a tailored user experience that aligns with your app’s branding.

- **Advanced Motion Recognition:**  
  Real-time feedback allows users to see their progress, correct their mistakes, and stay engaged throughout their fitness journey.

---

## **CAMERA Integration Example**

### **1. Displaying the KinesteXSDK Camera Component**

```dart
ValueListenableBuilder<String?>(
  valueListenable: updateExercise,
  builder: (context, value, _) {
    return KinesteXAIFramework.createCameraComponent(
      apiKey: apiKey, // Your unique API key
      companyName: company, // Name of your company
      isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
      userId: userId, // Unique identifier for the user
      exercises: ["Squats", "Lunges"], // List of exercises
      currentExercise: "Squats", // Current exercise being tracked
      updatedExercise: value, // Dynamic exercise updates
      isLoading: ValueNotifier<bool>(false), // Loading state
      onMessageReceived: (message) {
        handleWebViewMessage(message); // Handle incoming messages
      },
    );
  },
),
```

### **2. Updating the Current Exercise**
Easily update the exercise being tracked by modifying the notifier's value:

```dart
updateExercise.value = 'Lunges';
```

### **3. Handling Messages for Reps and Mistakes**
Track repetitions and identify mistakes made by users in real time:

```dart
ValueNotifier<int> reps = ValueNotifier<int>(0);
ValueNotifier<String> mistake = ValueNotifier<String>("--");

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
```

## Additional customization options you can pass in customParams: 
| Field | Description |
|-------|-------------|
| `videoURL` | If videoURL is specified, we will use it instead of camera |
| `landmarkColor` | Color of the pose connections and landmarks. Has to be in hex format with #. Example: "#14FF00" |
| `showSilhouette` | Whether or not to show the silhouette component prompting a user to get into the frame |
| `includePoseData` | string[]. Can contain either or all: ["angles", "poseLandmarks", "worldLandmarks"]. If "angles" is included, will return both 2D and 3D angles for specified poseLandmarks or/and worldLandmarks. **THIS WILL IMPACT PERFORMANCE**, so only include if you are planning to make custom calculations instead of relying on our existing exercises |

## Available message types that will be returned: 
| Event | Description |
|-------|-------------|
| `error_occurred` | includes `data` field with the error message |
| `warning` | Warning if exercise IDs models are not provided |
| `successful_repeat` | to indicate success rep, includes: `exercise` representative of currentExercise value, and `value` with an integer value of the total number of reps for the current exercise |
| `person_in_frame` | To indicate that person is in the frame |
| `pose_landmarks` | Includes `poseLandmarks` Object. Inside it has `coordinates`, `angles2D`, and `angles3D`. See below for all coordinate values |
| `world_landmarks` | Includes `worldLandmarks` Object. Inside it has `coordinates`, `angles2D`, and `angles3D`. See below for all coordinate values |

## Available coordinates and angles. 
Both poseLandmarks and worldLandmarks contain same naming conventions for coordinates and angles, but have different values depending because the point of reference is different. worldLandmarks are useful if you need to perform calculations regardless of the person's position in the camera frame since the main point of reference would be hips and person will be treated as always in the center of the frame. worldLandmarks have the most accurate z measurements. poseLandmarks are useful if you need to know person's position relative to the camera frame. 

- Available coordinates:
  ```js
  nose: Landmark;
  leftEyeInner: Landmark;
  leftEye: Landmark;
  leftEyeOuter: Landmark;
  rightEyeInner: Landmark;
  rightEye: Landmark;
  rightEyeOuter: Landmark;
  leftEar: Landmark;
  rightEar: Landmark;
  mouthLeft: Landmark;
  mouthRight: Landmark;
  leftShoulder: Landmark;
  rightShoulder: Landmark;
  leftElbow: Landmark;
  rightElbow: Landmark;
  leftWrist: Landmark;
  rightWrist: Landmark;
  leftPinky: Landmark;
  rightPinky: Landmark;
  leftIndex: Landmark;
  rightIndex: Landmark;
  leftThumb: Landmark;
  rightThumb: Landmark;
  leftHip: Landmark;
  rightHip: Landmark;
  leftKnee: Landmark;
  rightKnee: Landmark;
  leftAnkle: Landmark;
  rightAnkle: Landmark;
  leftHeel: Landmark;
  rightHeel: Landmark;
  leftFootIndex: Landmark;
  rightFootIndex: Landmark;

  ```
  Each Landmark has `x`, `y`, `z`, and `visibility` fields with values from 0 to 1 indicative of person's position or visibility of the given landmark
  - Available angles both in 2D using x and y coordinates and 3D using x, y, z. 
```js
    leftKneeAngle: number;
    rightKneeAngle: number;
    leftHipAngle: number;
    rightHipAngle: number;
    leftShoulderAngle: number;
    rightShoulderAngle: number;
    leftElbowAngle: number;
    rightElbowAngle: number;
    leftWristAngle: number;
    rightWristAngle: number;
    leftAnkleAngle: number;
    rightAnkleAngle: number;
```

- ### [View complete code example](../../examples/motion-analysis.md)
