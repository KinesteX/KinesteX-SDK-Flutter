# Admin Workout Editor Embedded View

The Admin Workout Editor is a customizable embedded view for creating and managing workouts and exercises. As users interact with the editor, your application will receive events that you can handle to trigger custom logic.

---

## Integration Example

This example shows how to create the admin workout editor view in your application.

```dart
KinesteXAIFramework.createAdminWorkoutEditor(
  apiKey: apiKey,
  companyName: company,
  userId: userId,
  // Use an organization name to differentiate between different orgs.
  // If you don't plan to use multiple orgs, you can use your company name.
  organization: "your_organization_name",
  isShowKinestex: showKinesteX,
  customParams: {
    "style": "dark", // "light" or "dark" theme (default is "dark")
  },
  isLoading: ValueNotifier<bool>(false),
  onMessageReceived: (message) {
    handleWebViewMessage(message);
  },
);
```

## Available Events

You can listen for the following events dispatched from the editor via the `onMessageReceived` callback.

| Event Type | Data Type | Properties | Description |
| :--- | :--- | :--- | :--- |
| `kinestex_loaded` | None | None | Fires when the editor has fully loaded and is ready. |
| `kinestex_launched` | None | None | Fires after the user has been successfully authenticated. |
| `workout_opened` | Object | `workout_id: string`<br>`workout_title: string` | Fires when a user opens a specific workout. |
| `workout_selection_opened` | None | None | Fires when the user navigates to the workout selection screen. |
| `exercise_selection_opened` | Object | `from_workout_id: string` | Fires when the user opens the exercise selection screen to add an exercise to a workout. |
| `exercise_opened` | Object | `exercise_id: string`<br>`exercise_title: string` | Fires when a user opens a specific exercise. |
| `exercise_removed` | Object | `workout_id: string`<br>`exercise_id: string` | Fires when an exercise is removed from a workout. |
| `workout_saved` | Object | `workout_id: string`<br>`workout_title: string` | Fires when a workout is saved. |
| `exercise_saved` | Object | `exercise_id: string`<br>`exercise_title: string` | Fires when an exercise is saved. |
| `error_occurred` | Object | `error_message: string`<br>`severity: "high" \| "medium" \| "low"` | Fires when an error occurs. Includes a message and severity level. |

## Next Steps

*   [Explore more integration options](../overview.md)