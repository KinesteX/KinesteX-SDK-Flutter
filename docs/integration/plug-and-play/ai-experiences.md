# Immersive AI Experiences: Captivate and Motivate Your Users

### **Engaging AI-Powered Fitness**
Deliver captivating fitness experiences with our cutting-edge AI solutions designed to immerse users in interactive and dynamic workouts.

### **"Fight with a Shadow"**
Our first AI-driven experience, "Fight with a Shadow," leverages advanced pose motion analysis to provide real-time feedback on:
- Punching technique
- Stance and form
- Total punch count

This experience features a **virtual dynamic punching bag** that reacts to every hit, offering an interactive and motivating fitness journey that keeps users fully engaged.

---

# **EXPERIENCE Integration Example**

```dart
KinesteXAIFramework.createExperienceView(
  apiKey: apiKey, // Your unique API key
  companyName: company, // Name of your company
  isShowKinestex: showKinesteX, // Boolean to show KinesteX branding
  userId: userId, // Unique identifier for the user
  experience: "box", // Specify the experience (e.g., "box")
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
- [View handleWebViewMessage available data points](../../data.md)
- [View complete code example](../../examples/ai-experiences.md)
- [Explore more integration options](../overview.md)
