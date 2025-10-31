# Admin Workout Editor Embedded View

The Admin Workout Editor is a customizable embedded view for creating and managing workouts and exercises. As users interact with the editor, your application will receive events that you can handle to trigger custom logic.

---

## Integration Example

This example shows how to create the admin workout editor view in your application.

```dart
KinesteXAIFramework.createAdminWorkoutEditor(
  // Use an organization name to differentiate between different orgs.
  // If you don't plan to use multiple orgs, you can use your company name.
  organization: "your_organization_name",
  isShowKinestex: showKinesteX,
  // OPTIONAL: show/hide content on the admin dashboard
  customQueries: { 
            "hidePlansTab": true, // will hide the plans tabs in the dashboard
            "tab": "workouts", // will default to workouts tab. You can choose "exercises" or "plans" as well
            "isSelectableMenu": true // will show select Button on workout, exercises, and plans cards, clicking on which will trigger ..._selected event (see below)
   },
  isLoading: ValueNotifier<bool>(false),
  onMessageReceived: (message) {
    handleWebViewMessage(message);
  },
);
```

## Available Events

You can listen for the following events dispatched from the editor via the `onMessageReceived` callback.

### General/System Events

| Event Type | Payload | Description |
|------------|---------|-------------|
| `kinestex_loaded` | `{ type: "kinestex_loaded" }` | Fired when the application has fully loaded and initialized |
| `kinestex_launched` | `{ type: "kinestex_launched" }` | Fired after successful authentication through custom auth flow |
| `error_occurred` | `{ type: "error_occurred", error_message: string }` | Fired when an authentication error occurs |

### Exercise Events

| Event Type | Payload | Description |
|------------|---------|-------------|
| `exercise_opened` | `{ type: "exercise_opened", exercise_id: string, exercise_title: string }` | Fired when an exercise detail page is opened |
| `exercise_selection_opened` | `{ type: "exercise_selection_opened", from_workout_id?: string }` | Fired when the exercise selection/list page is opened, optionally from a workout context |
| `exercise_selected` | `{ type: "exercise_selected", exercise_id: string, exercise_title: string }` | Fired when an exercise is selected from the selection menu |
| `exercise_saved` | `{ type: "exercise_saved", exercise_id: string }` | Fired after successfully creating or updating an exercise |
| `exercise_removed` | `{ type: "exercise_removed", workout_id: string, exercise_id: string }` | Fired when an exercise is removed from a workout sequence |

### Workout Events

| Event Type | Payload | Description |
|------------|---------|-------------|
| `workout_opened` | `{ type: "workout_opened", workout_id: string, workout_title: string }` | Fired when a workout detail page is opened |
| `workout_selection_opened` | `{ type: "workout_selection_opened" }` | Fired when the workout selection/list page is opened |
| `workout_selected` | `{ type: "workout_selected", workout_id: string, workout_title: string }` | Fired when a workout is selected from the selection menu |
| `workout_saved` | `{ type: "workout_saved", workout_id: string }` | Fired after successfully creating or updating a workout |

### Plan Events

| Event Type | Payload | Description |
|------------|---------|-------------|
| `plan_opened` | `{ type: "plan_opened", plan_id: string, plan_title: string }` | Fired when a plan detail page is opened |
| `plan_selection_opened` | `{ type: "plan_selection_opened" }` | Fired when the plan selection/list page is opened |
| `plan_selected` | `{ type: "plan_selected", plan_id: string, plan_title: string }` | Fired when a plan is selected from the selection menu |
| `plan_saved` | `{ type: "plan_saved", plan_id: string }` or `{ type: "plan_saved", workout_id: string }` | Fired after successfully creating or updating a plan (note: second variant appears to be a typo in the code) |


## Next Steps

*   [Explore more integration options](../overview.md)
