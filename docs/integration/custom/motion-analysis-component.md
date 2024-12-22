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

- ### [View complete code example](../../examples/motion-analysis.md)