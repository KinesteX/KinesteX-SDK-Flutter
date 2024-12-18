## Data Points

The KinesteX SDK provides various data points that are returned through the `handleWebViewMessage` callback function. Below is a complete example function demonstrating how to handle different message types, followed by detailed descriptions of each message type:

### **Message Types and Usage**

| **Type**                  | **Data**                                                                                   | **Description**                                                                                              |
|---------------------------|-------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `kinestex_launched`       | `dd mm yyyy hours:minutes:seconds`                                                        | Logs when a user has launched KinesteX.                                                                      |
| `exit_kinestex`           | `date: dd mm yyyy hours:minutes:seconds`, `time_spent: number`                            | Logs when a user clicks the exit button and the total time spent.                                            |
| `plan_unlocked`           | `title: String, date: date and time`                                                     | Logs when a workout plan is unlocked by a user.                                                             |
| `workout_opened`          | `title: String, date: date and time`                                                     | Logs when a workout is opened by a user.                                                                    |
| `workout_started`         | `title: String, date: date and time`                                                     | Logs when a workout is started by a user.                                                                   |
| `exercise_completed`      | `time_spent: number`, `repeats: number`, `calories: number`, `exercise: string`, `mistakes: [string: number]` | Logs each time a user finishes an exercise.                                                                  |
| `total_active_seconds`    | `number`                                                                                 | Logs every 5 seconds, counting the active seconds a user has spent working out.                             |
| `left_camera_frame`       | `number`                                                                                 | Indicates that a user has left the camera frame.                                                            |
| `returned_camera_frame`   | `number`                                                                                 | Indicates that a user has returned to the camera frame.                                                     |
| `workout_overview`        | `workout: string`, `total_time_spent: number`, `total_repeats: number`, `total_calories: number`, `percentage_completed: number`, `total_mistakes: number` | Logs a complete summary of the workout.                                                                     |
| `exercise_overview`       | `[exercise_completed]`                                                                  | Returns a log of all exercises and their data.                                                              |
| `workout_completed`       | `workout: string`, `date: dd mm yyyy hours:minutes:seconds`                              | Logs when a user finishes the workout and exits the workout overview.                                       |
| `active_days` (Coming soon)| `number`                                                                                | Represents the number of days a user has been opening KinesteX.                                             |
| `total_workouts` (Coming soon)| `number`                                                                            | Represents the number of workouts a user has done since starting to use KinesteX.                           |
| `workout_efficiency` (Coming soon)| `number`                                                                        | Represents the level of intensity with which a person has completed the workout.                            |

### **Complete Example Function**
```dart
void handleWebViewMessage(WebViewMessage message) {
  if (message is KinestexLaunched) {
    print("KinesteX launched at: ${message}");
  } else if (message is ExitKinestex) {
    print("Exited KinesteX at: ${message} seconds.");
  } else if (message is PlanUnlocked) {
    print("Plan Unlocked: ${message}");
  } else if (message is WorkoutOpened) {
    print("Workout Opened: ${message}");
  } else if (message is WorkoutStarted) {
    print("Workout Started: ${message}");
  } else if (message is ExerciseCompleted) {
    print("Exercise: ${message}");
  } else if (message is TotalActiveSeconds) {
    print("Active seconds: ${message}");
  } else if (message is LeftCameraFrame) {
    print("User left camera frame at time: ${message}");
  } else if (message is ReturnedCameraFrame) {
    print("User returned to camera frame at time: ${message}");
  } else if (message is WorkoutOverview) {
    print("Workout Overview: ${message}");
  } else if (message is ExerciseOverview) {
    print("Exercise Overview: ${message}");
  } else if (message is WorkoutCompleted) {
    print("Workout Completed: ${message}");
  } else {
    print("Unhandled message: ${message.data}");
  }
}
```


## Contact

If you have any questions, contact: [support@kinestex.com](mailto:support@kinestex.com)
