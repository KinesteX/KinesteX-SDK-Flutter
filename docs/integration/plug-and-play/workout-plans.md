# Key Features of Our Workout Plans

### **Personalized Workout Plans**
Our workout plans are uniquely tailored to each user, taking into account key specifics like height, weight, age, and activity level. This ensures a personalized, comprehensive, and effective fitness journey for every individual.

### **Achieve Your Fitness Goals**
Whether users aim to build strength, improve flexibility, or maintain a healthy lifestyle, our structured and adaptable plans are designed to help them achieve their fitness objectives efficiently.

### **End-to-End User Journey Management**
We handle the entire user journey—from providing initial workout recommendations to real-time movement monitoring and feedback. This seamless integration ensures consistent communication and actionable insights for a superior user experience.

### **Fully Customizable Design**
Our platform allows you to customize the app's design to match your branding. This not only enhances user engagement but also strengthens brand loyalty and retention.

### **Rapid Integration**
Easily integrate our solution into your system. With quick setup and seamless onboarding, you can provide cutting-edge fitness experiences tailored to your audience in no time.

---

# **PLAN Integration Example**

```dart
KinesteXAIFramework.createPlanView(
  apiKey: apiKey, // Your unique API key
  companyName: company, // Name of your company
  userId: userId, // Unique identifier for the user
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  planName: "Circuit Training", // Specify the plan name here
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
- ### [View complete code example](../../examples/plans.md)
- ### [Explore more integration options](../overview.md)
