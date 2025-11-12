# KinesteX Workout, Plans, and Exercises API

`KinesteXAIFramework` enables you to fetch our diverse content data such as workouts, plans, and exercises. Whether you're building a fitness app, a training platform, or any content-driven application, `KinesteXAIFramework` provides a robust and easy-to-use API to enhance your app's functionality.

## Features

- **Flexible Content Fetching:** Retrieve workouts, plans, and exercises based on various parameters and filters using `KinesteXAIFramework`.
- **Robust Models:** Comprehensive data models representing different content types.
- **Asynchronous Operations:** Efficient data fetching with `async/await` support using Dart's `Future` API.
- **Error Handling:** Detailed error messages and validation to ensure data integrity.

## Installation

### Using pub.dev

Add `kinestex_sdk_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  kinestex_sdk_flutter: ^latest_version
```

Then run:

```bash
flutter pub get
```

### From GitHub

Alternatively, you can add it directly from the GitHub repository:

```yaml
dependencies:
  kinestex_sdk_flutter:
    git:
      url: https://github.com/KinesteX/KinesteX-SDK-Flutter.git
      ref: main
```

## Usage

### Initializing KinesteXAIFramework

Before fetching content, you need to initialize `KinesteXAIFramework` with your API key, company name, and a user ID.

```dart
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

// Initialize KinesteXAIFramework in your main.dart or app initialization
await KinesteXAIFramework.initialize(
  apiKey: "yourApiKey",
  companyName: "YourCompany",
  userId: "currentUser_123",
);
```

### Fetching Content Data

To fetch content data such as workouts, plans, or exercises, use the `fetchContent` method on the API service instance. This asynchronous function allows you to specify `contentType` and various filtering options such as `id`, `title`, `category`, and `bodyParts`.

The API service is accessible through `KinesteXAIFramework.apiService` after initialization.

#### Parameters for `fetchContent`:

- `contentType` (ContentType): The type of content to fetch (`.workout`, `.plan`, `.exercise`).
- `id` (String?, optional): Unique identifier for the content. Overrides other search parameters if provided.
- `title` (String?, optional): Title to search for the content when `id` is not provided.
- `category` (String?, optional): Category to filter workouts and plans.
- `bodyParts` (List\<BodyPart\>?, optional): Array of `BodyPart` to filter workouts, plans, and exercises.
- `lang` (String, optional): Language for the content (default is `"en"`).
- `lastDocId` (String?, optional): Document ID for pagination; fetches content after this ID.
- `limit` (int?, optional): Limit on the number of items to fetch.

### Models

KinesteXAIFramework includes several data models representing different content types:

- **WorkoutModel:** Details about a workout.
- **ExerciseModel:** Details about an exercise.
- **PlanModel:** Information about a workout plan.
- **Additional Models:** Supporting models like `PlanModelCategory`, `PlanLevel`, `PlanDay`, and `WorkoutSummary`.
- **Response Models:** `WorkoutsResponse`, `ExercisesResponse`, `PlansResponse` for handling paginated list results.
- **BodyPart Enum:** Represents body parts for filtering content.
- **ContentType Enum:** Represents the type of content to fetch.

### Using Filtering Options with `KinesteXAIFramework`

#### Fetching Workouts by Category

```dart
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

// Assume KinesteXAIFramework is already initialized
// await KinesteXAIFramework.initialize(apiKey: "yourApiKey", companyName: "MyCompany", userId: "user123");

Future<void> fetchWorkoutsByCategory() async {
  final result = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.workout,
    category: "Fitness", // "Rehabilitation"
    limit: 5,
  );

  switch (result) {
    case WorkoutsResult(:final response):
      final workouts = response.workouts;
      // Handle workouts data
      print('Fetched ${workouts.length} workouts.');
      for (final workout in workouts) {
        print('- ${workout.title}');
      }

    case ErrorResult(:final message):
      print('Error fetching workouts: $message');

    default:
      print('Unexpected result type');
  }
}
```

#### Fetching Exercises by Body Parts

```dart
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

// Assume KinesteXAIFramework is already initialized
// await KinesteXAIFramework.initialize(apiKey: "yourApiKey", companyName: "MyCompany", userId: "user123");

Future<void> fetchExercisesByBodyParts() async {
  final result = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.exercise,
    bodyParts: [BodyPart.abs, BodyPart.glutes],
    limit: 10,
  );

  switch (result) {
    case ExercisesResult(:final response):
      final exercises = response.exercises;
      // Handle exercises data
      print('Fetched ${exercises.length} exercises.');
      for (final exercise in exercises) {
        print('- ${exercise.title}');
      }

    case ErrorResult(:final message):
      print('Error fetching exercises: $message');

    default:
      print('Unexpected result type');
  }
}
```

#### Fetching Plans by Category and Body Parts

```dart
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

// Assume KinesteXAIFramework is already initialized
// await KinesteXAIFramework.initialize(apiKey: "yourApiKey", companyName: "MyCompany", userId: "user123");

Future<void> fetchPlansByCategoryAndBodyParts() async {
  final result = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.plan,
    category: "Strength",
    bodyParts: [BodyPart.biceps, BodyPart.triceps],
    limit: 3,
  );

  switch (result) {
    case PlansResult(:final response):
      final plans = response.plans;
      // Handle plans data
      print('Fetched ${plans.length} plans.');
      for (final plan in plans) {
        print('- ${plan.title}');
      }

    case ErrorResult(:final message):
      print('Error fetching plans: $message');

    default:
      print('Unexpected result type');
  }
}
```

#### Fetching Plans by Category with Pagination

The `lastDocId` parameter is returned in your initial query (e.g., in `PlansResponse.lastDocId`) and can be used to fetch the next set of results.

```dart
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

// Assume KinesteXAIFramework is already initialized and lastDocId was obtained from a previous fetch
// await KinesteXAIFramework.initialize(apiKey: "yourApiKey", companyName: "MyCompany", userId: "user123");

Future<void> fetchPlansWithPagination() async {
  String? lastDocId;
  List<PlanModel> allPlans = [];

  // Fetch initial page
  final initialResult = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.plan,
    category: "Strength",
    limit: 5,
  );

  switch (initialResult) {
    case PlansResult(:final response):
      allPlans.addAll(response.plans);
      lastDocId = response.lastDocId; // Store for next fetch
      print('Fetched initial ${response.plans.length} plans. Next ID: ${lastDocId.isEmpty ? "None" : lastDocId}');

      // To fetch the next page:
      if (lastDocId.isNotEmpty) {
        final nextResult = await KinesteXAIFramework.apiService.fetchContent(
          contentType: ContentType.plan,
          category: "Strength",
          lastDocId: lastDocId,
          limit: 5,
        );

        switch (nextResult) {
          case PlansResult(:final nextPageResponse):
            allPlans.addAll(nextPageResponse.plans);
            lastDocId = nextPageResponse.lastDocId; // Update for subsequent pages
            print('Fetched next ${nextPageResponse.plans.length} plans. Total: ${allPlans.length}');

          case ErrorResult(:final message):
            print('Error fetching next page of plans: $message');

          default:
            print('Unexpected result type');
        }
      }

    case ErrorResult(:final message):
      print('Error fetching initial plans: $message');

    default:
      print('Unexpected result type');
  }
}
```

## API Reference

### `KinesteXAIFramework`

The main framework class used to interact with the KinesteX API.

#### Initialization

```dart
static Future<void> initialize({
  required String apiKey,
  required String companyName,
  required String userId,
})
```

#### Accessing API Service

After initialization, access the API service through:

```dart
final apiService = KinesteXAIFramework.apiService;
```

### `fetchContent`

A method on the API service instance to fetch content data from the API.

#### Signature

```dart
Future<APIContentResult> fetchContent({
  required ContentType contentType,
  String? id,
  String? title,
  String lang = "en",
  String? category,
  List<BodyPart>? bodyParts,
  String? lastDocId,
  int? limit,
})
```

#### Parameters:

- **contentType**: The type of content to fetch (`.workout`, `.plan`, `.exercise`).
- **id**: Unique identifier for the content. Overrides other search parameters if provided.
- **title**: Title to search for the content when `id` is not provided.
- **lang**: Language for the content (default is `"en"`).
- **category**: Category to filter workouts and plans.
- **bodyParts**: Array of `BodyPart` to filter workouts, plans, and exercises.
- **lastDocId**: Document ID for pagination; fetches content after this ID.
- **limit**: Limit on the number of items to fetch.

#### Example Usage:

Refer to the [Using Filtering Options with KinesteXAIFramework](#using-filtering-options-with-kinestexaiframework) section above for examples.

### `APIContentResult`

A sealed class representing the result of a `fetchContent` API request. It can be one of the following:

-   `WorkoutsResult(WorkoutsResponse)`: Successfully fetched a list of workouts.
-   `WorkoutResult(WorkoutModel)`: Successfully fetched a single workout.
-   `PlansResult(PlansResponse)`: Successfully fetched a list of plans.
-   `PlanResult(PlanModel)`: Successfully fetched a single plan.
-   `ExercisesResult(ExercisesResponse)`: Successfully fetched a list of exercises.
-   `ExerciseResult(ExerciseModel)`: Successfully fetched a single exercise.
-   `ErrorResult(String)`: An error occurred with an associated message.
-   `RawDataResult(Map<String, dynamic>, String?)`: Raw JSON data was returned, possibly due to a parsing issue. The `String?` contains an optional error message.

### `ContentType` Enum

Represents the types of content that can be fetched.

```dart
enum ContentType {
  workout,  // Fetch workouts
  plan,     // Fetch workout plans
  exercise  // Fetch exercises
}
```

### `BodyPart` Enum

An enumeration representing the body parts that can be used for filtering content.

```dart
enum BodyPart {
  abs,              // Abs
  biceps,           // Biceps
  calves,           // Calves
  chest,            // Chest
  externalOblique,  // External Oblique
  forearms,         // Forearms
  glutes,           // Glutes
  neck,             // Neck
  quads,            // Quads
  shoulders,        // Shoulders
  triceps,          // Triceps
  hamstrings,       // Hamstrings
  lats,             // Lats
  lowerBack,        // Lower Back
  traps,            // Traps
  fullBody          // Full Body
}
```

## Error Handling

`KinesteXAIFramework` provides error handling through the `APIContentResult` sealed class (specifically the `ErrorResult` and `RawDataResult` cases) when using `fetchContent`.

-   **Validation Errors:** The API service methods internally validate input parameters. If validation fails, operations may terminate early or return an error.
-   **Network Errors:** Issues related to network connectivity will result in an `ErrorResult`.
-   **Parsing Errors:** If data cannot be parsed correctly, the method might return the `RawDataResult` case, allowing you to inspect the raw response.
-   **API Response Errors:** Errors returned by the API are captured and provided in the error messages.

**Example Error Handling:**

```dart
Future<void> fetchWorkoutWithErrorHandling() async {
  final result = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.workout,
    id: "nonExistentId",
  );

  switch (result) {
    case WorkoutResult(:final workout):
      // Process workout
      print('Fetched workout: ${workout.title}');

    case ErrorResult(:final message):
      // Handle error
      print('Error fetching workout: $message');

    case RawDataResult(:final data, :final errorMessage):
      // Parsing failed but got raw data
      print('Parse error: ${errorMessage ?? "Unknown error"}');
      // Can still access data manually
      print('Raw data keys: ${data.keys}');

    default:
      print('Unexpected result type');
  }
}
```

**Validation for Parameters:**

-   Ensure that `category` and each `BodyPart` value (when used as strings in API calls) do not contain disallowed characters. The SDK handles appropriate encoding for URL parameters.
-   If validation fails internally, the request will terminate with an appropriate error message or an empty/error result.

## Data Models Reference

### WorkoutModel

Represents a complete workout with all its details.

```dart
class WorkoutModel {
  final String id;
  final String title;
  final String imgURL;                 // From 'workout_desc_img'
  final String? category;
  final String description;
  final int? totalMinutes;
  final int? totalCalories;            // From 'calories'
  final List<String> bodyParts;
  final String? difficultyLevel;       // From 'dif_level'
  final List<ExerciseModel> sequence;  // List of exercises
  final Map<String, dynamic>? rawJSON; // Raw API response
}
```

### ExerciseModel

Represents a single exercise with all its details.

```dart
class ExerciseModel {
  final String id;
  final String title;
  final String thumbnailURL;
  final String videoURL;
  final String maleVideoURL;
  final String maleThumbnailURL;
  final int? workoutCountdown;         // Specific to workout
  final int? workoutReps;              // Specific to workout
  final int? averageReps;              // General average
  final int? averageCountdown;         // General average
  final int restDuration;              // Extracted from sequence
  final String restSpeech;
  final String restSpeechText;
  final double? averageCalories;
  final List<String> bodyParts;
  final String description;
  final String difficultyLevel;
  final String commonMistakes;
  final List<String> steps;
  final String tips;
  final String modelId;
  final Map<String, dynamic>? rawJSON; // Raw API response
}
```

### PlanModel

Represents a workout plan with hierarchical structure.

```dart
class PlanModel {
  final String id;
  final String imgURL;
  final String title;
  final PlanModelCategory category;
  final Map<String, PlanLevel> levels;  // e.g., "1", "2", "3"
  final String createdBy;
  final Map<String, dynamic>? rawJSON;  // Raw API response
}

class PlanModelCategory {
  final String description;
  final Map<String, int> levels;
  final Map<String, dynamic>? rawJSON;
}

class PlanLevel {
  final String title;
  final String description;
  final Map<String, PlanDay> days;      // e.g., "1", "2", "3"
  final Map<String, dynamic>? rawJSON;
}

class PlanDay {
  final String title;
  final String description;
  final List<WorkoutSummary>? workouts;
  final Map<String, dynamic>? rawJSON;
}

class WorkoutSummary {
  final String id;
  final String imgURL;
  final String title;
  final double? calories;
  final int totalMinutes;
  final Map<String, dynamic>? rawJSON;
}
```

### Response Models (Paginated)

```dart
class WorkoutsResponse {
  final List<WorkoutModel> workouts;
  final String lastDocId;              // For pagination
  final Map<String, dynamic>? rawJSON;
}

class ExercisesResponse {
  final List<ExerciseModel> exercises;
  final String lastDocId;              // For pagination
  final Map<String, dynamic>? rawJSON;
}

class PlansResponse {
  final List<PlanModel> plans;
  final String lastDocId;              // For pagination
  final Map<String, dynamic>? rawJSON;
}
```

## Complete Example: Workout Browser App

Here's a complete example showing how to build a workout browser with filtering and detail views:

```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize KinesteX SDK
  await KinesteXAIFramework.initialize(
    apiKey: "your-api-key",
    companyName: "your-company",
    userId: "user-123",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX Content Browser',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WorkoutListScreen(),
    );
  }
}

class WorkoutListScreen extends StatefulWidget {
  const WorkoutListScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutListScreen> createState() => _WorkoutListScreenState();
}

class _WorkoutListScreenState extends State<WorkoutListScreen> {
  List<WorkoutModel> workouts = [];
  bool isLoading = true;
  String? error;
  String? selectedCategory;
  List<BodyPart> selectedBodyParts = [];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final result = await KinesteXAIFramework.apiService.fetchContent(
      contentType: ContentType.workout,
      category: selectedCategory,
      bodyParts: selectedBodyParts.isEmpty ? null : selectedBodyParts,
      limit: 20,
    );

    setState(() {
      isLoading = false;

      switch (result) {
        case WorkoutsResult(:final response):
          workouts = response.workouts;

        case WorkoutResult(:final workout):
          workouts = [workout];

        case ErrorResult(:final message):
          error = message;

        default:
          error = 'Unexpected error occurred';
      }
    });
  }

  void _showFilters() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Workouts'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category filter
            DropdownButton<String?>(
              value: selectedCategory,
              hint: const Text('Select Category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Categories')),
                const DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
                const DropdownMenuItem(value: 'Rehabilitation', child: Text('Rehabilitation')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
                Navigator.pop(context);
                _loadWorkouts();
              },
            ),
            const SizedBox(height: 16),
            // Body parts filter
            const Text('Body Parts:'),
            Wrap(
              spacing: 8,
              children: BodyPart.values.map((bodyPart) {
                final isSelected = selectedBodyParts.contains(bodyPart);
                return FilterChip(
                  label: Text(bodyPart.value),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedBodyParts.add(bodyPart);
                      } else {
                        selectedBodyParts.remove(bodyPart);
                      }
                    });
                    Navigator.pop(context);
                    _loadWorkouts();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadWorkouts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (workouts.isEmpty) {
            return const Center(
              child: Text('No workouts found'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final workout = workouts[index];
              return WorkoutCard(
                workout: workout,
                onTap: () => _showWorkoutDetails(workout),
              );
            },
          );
        },
      ),
    );
  }

  void _showWorkoutDetails(WorkoutModel workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutDetailScreen(workout: workout),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final WorkoutModel workout;
  final VoidCallback onTap;

  const WorkoutCard({
    Key? key,
    required this.workout,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(
                workout.imgURL,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.error)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${workout.totalMinutes ?? "N/A"} min • ${workout.totalCalories ?? "N/A"} cal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  if (workout.difficultyLevel != null)
                    Text(
                      workout.difficultyLevel!,
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailScreen({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              workout.imgURL,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(label: Text('${workout.totalMinutes ?? "N/A"} min')),
                      const SizedBox(width: 8),
                      Chip(label: Text('${workout.totalCalories ?? "N/A"} cal')),
                      const SizedBox(width: 8),
                      if (workout.difficultyLevel != null)
                        Chip(label: Text(workout.difficultyLevel!)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(workout.description),
                  const SizedBox(height: 16),
                  const Text(
                    'Body Parts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: workout.bodyParts
                        .map((part) => Chip(label: Text(part)))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Exercises (${workout.sequence.length})',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...workout.sequence.map((exercise) => ListTile(
                        leading: Image.network(
                          exercise.thumbnailURL,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        title: Text(exercise.title),
                        subtitle: Text(
                          'Reps: ${exercise.workoutReps ?? exercise.averageReps ?? "N/A"} • '
                          'Countdown: ${exercise.workoutCountdown ?? exercise.averageCountdown ?? "N/A"}s',
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Best Practices

### 1. Initialize Once

Initialize the framework in your app's main method or during app startup:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await KinesteXAIFramework.initialize(
    apiKey: "your-api-key",
    companyName: "your-company",
    userId: "user-id",
  );

  runApp(MyApp());
}
```

### 2. Handle All Result Types

Always use pattern matching to handle all possible result types:

```dart
final result = await KinesteXAIFramework.apiService.fetchContent(...);

switch (result) {
  case WorkoutsResult(:final response):
    // Handle list of workouts

  case WorkoutResult(:final workout):
    // Handle single workout

  case PlansResult(:final response):
    // Handle list of plans

  case PlanResult(:final plan):
    // Handle single plan

  case ExercisesResult(:final response):
    // Handle list of exercises

  case ExerciseResult(:final exercise):
    // Handle single exercise

  case ErrorResult(:final message):
    // Handle API errors

  case RawDataResult(:final data, :final errorMessage):
    // Handle parsing errors, inspect raw data
}
```

### 3. Use Pagination for Large Datasets

```dart
String? lastDocId;
List<WorkoutModel> allWorkouts = [];

Future<void> loadMoreWorkouts() async {
  final result = await KinesteXAIFramework.apiService.fetchContent(
    contentType: ContentType.workout,
    category: "Fitness",
    limit: 20,
    lastDocId: lastDocId,
  );

  if (result is WorkoutsResult) {
    allWorkouts.addAll(result.response.workouts);
    lastDocId = result.response.lastDocId;
  }
}
```

### 4. Access Raw JSON When Needed

All models include a `rawJSON` property for accessing the complete API response:

```dart
if (result is WorkoutResult) {
  final workout = result.workout;

  // Access parsed data
  print(workout.title);

  // Access raw JSON for additional/custom fields
  final customField = workout.rawJSON?['custom_field'];
}
```

### 5. Implement Caching

Consider caching frequently accessed content to reduce API calls:

```dart
class ContentCache {
  static final Map<String, WorkoutModel> _workoutCache = {};

  static Future<WorkoutModel?> getWorkout(String id) async {
    // Check cache first
    if (_workoutCache.containsKey(id)) {
      return _workoutCache[id];
    }

    // Fetch from API
    final result = await KinesteXAIFramework.apiService.fetchContent(
      contentType: ContentType.workout,
      id: id,
    );

    if (result is WorkoutResult) {
      _workoutCache[id] = result.workout;
      return result.workout;
    }

    return null;
  }
}
```

## Support

For any questions, issues, or feature requests, please contact us at [support@kinestex.com](mailto:support@kinestex.com).

## Next Steps

### [> Example project](./README.md)

Explore the complete demo application in this repository that showcases:
- Content browsing with filters
- Detailed workout, exercise, and plan views
- State management with BLoC/Cubit
- Video playback
- Responsive UI design
