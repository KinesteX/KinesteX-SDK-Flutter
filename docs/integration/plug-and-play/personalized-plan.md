# (Beta) Key Features of Our Personalized Workout Plan

### **Personalized Workout Plan**
Our workout plans are uniquely tailored to each user, taking into account key specifics like height, weight, age, activity level, and fitness assessment score. This ensures a personalized, comprehensive, and effective fitness journey for every individual.

### **End-to-End User Journey Management**
We handle the entire user journey—from providing initial workout recommendations to real-time movement monitoring and feedback. This seamless integration ensures consistent communication and actionable insights for a superior user experience.

### **Rapid Integration**
Easily integrate our solution into your system. With quick setup and seamless onboarding, you can provide cutting-edge fitness experiences tailored to your audience in no time.

---

# **Personalized Plan Integration Example**

```dart
KinesteXAIFramework.createPersonalizedPlanView(
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  customParams: {
    "style": "dark", // light or dark theme (default is dark)
  },
  isLoading: ValueNotifier<bool>(false), // Loading state
  onMessageReceived: (message) { 
    handleWebViewMessage(message); // Handle incoming messages
  }
);
``` 

# Next steps:
- ### [View handleWebViewMessage available data points](../../data.md)
- ### [Explore more integration options](../overview.md)
