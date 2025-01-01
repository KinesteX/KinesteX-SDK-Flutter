# Ready-made Leaderboard: Boost User Engagement and Motivation

### Adaptive Design
The leaderboard automatically adapts to your KinesteX UI and can be fully customized in the admin dashboard.

### Real-time Updates
Whenever a new ranking is available, the leaderboard automatically refreshes to show the latest standings.

---

# **LEADERBOARD Integration Example**

```dart
KinesteXAIFramework.createLeaderboardView(
  apiKey: apiKey, // Your unique API key
  companyName: company, // Name of your company
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  userId: userId, // Unique identifier for the user
  exercise: "Squats", // Specify the exercise title
  username: "", // if you know the username a person has entered: you can highlight the user by specifying their username
  customParams: {
    "style": "dark", // light or dark theme (default is dark)
    "isHideHeaderMain": true, // OPTIONAL: hide the exit button from the leaderboard
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
