# Exciting Challenges: Boost User Engagement and Motivation

### **Create an Engaging User Journey**
Delight your users with fun and competitive exercise challenges. These quick individual exercises are perfect for fostering a sense of achievement and promoting friendly competition through leaderboards.

### **Enhance Engagement**
Motivate users to stay active and committed by integrating regular exercise challenges that keep fitness exciting and rewarding.

### **Seamless Integration**
Effortlessly incorporate this feature into your app to deliver dynamic and enjoyable exercise experiences. Challenges are designed to be quick to set up and highly impactful in boosting user retention.

---

## **CHALLENGE Integration Example**

```dart
KinesteXAIFramework.createChallengeView(
  apiKey: apiKey, // Your unique API key
  companyName: company, // Name of your company
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  userId: userId, // Unique identifier for the user
  exercise: "Squats", // Specify the exercise title
  countdown: 100, // Countdown timer in seconds
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
- [View complete code example challenge](../../examples/challenge.md)
- [Explore more integration options](../overview.md)