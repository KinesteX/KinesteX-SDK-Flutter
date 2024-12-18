# Personalized Workouts: Engage Your Users Anytime, Anywhere

### **Tailored Workouts for Every Fitness Level**
Offer your users workouts designed to match their fitness level and goals, whether they’re aiming to get stronger, improve flexibility, or simply wind down after a long day with a quick stretching or mobility session.

### **Convenience at Its Best**
Short on time? No problem! Our solution is perfect for users seeking quick and efficient workouts without the need to commit to a full workout plan. We manage the entire user experience, making fitness accessible and hassle-free.

### **Boost User Engagement**
Keep your users engaged with varied, exciting, and personalized workouts that bring freshness to their fitness routine, ensuring they stay motivated and connected to your app.

### **Modular Integration Made Simple**
Quickly add dynamic workout experiences to your app without the complexity of integrating full workout plans. Provide instant value to your users with minimal setup.

---

## **WORKOUT Integration Example**

```dart
KinesteXAIFramework.createWorkoutView(
  apiKey: apiKey, // Your unique API key
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  companyName: company, // Name of your company
  userId: userId, // Unique identifier for the user
  workoutName: "Fitness Lite", // Specify the workout name or ID here
  customParams: {
    "style": "dark", // light or dark theme (default is dark)
  },
  isLoading: ValueNotifier<bool>(false), // Loading state
  onMessageReceived: (message) {
    handleWebViewMessage(message); // Handle incoming messages
  }
);
```

## Next steps:
- [View handleWebViewMessage available data points](../../data.md)
- [View complete code example challenge](../../examples/workouts.md)
- [Explore more integration options](../overview.md)