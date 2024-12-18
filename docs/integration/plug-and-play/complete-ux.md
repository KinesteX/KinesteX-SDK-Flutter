# Compelete User Experience (createMainView): 
With this integration option we displays 3 best workout plans based on the provided category. The user can select one of the plans and start a long-term routine.

- Available Categories to Sort Plans

| **Plan Category (key: planCategory)** |
|---------------------------------------|
| **Strength**                          |
| **Cardio**                            |
| **Weight Management**                 |
| **Rehabilitation**                    |
| **Custom**                            |

- Displaying the main view:
```dart
  Widget createMainView() {
    return Center(
      child: KinesteXAIFramework.createMainView(
        apiKey: apiKey,
        companyName: company,
        isShowKinestex: showKinesteX,
        userId: userId,
        planCategory: PlanCategory.Cardio,
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
```
## Next steps:
- [View handleWebViewMessage available data points](../../data.md)
- [View complete code example](../../examples/complete-ux.md)
- [Explore more integration options](../overview.md)