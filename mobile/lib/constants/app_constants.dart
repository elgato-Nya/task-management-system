/// Application-wide constants
class AppConstants {
  /// Private constructor to prevent instantiation
  AppConstants._();

  // Task Status Constants
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusCompleted = 'completed';

  // Task Priority Constants
  static const String priorityLow = 'low';
  static const String priorityMedium = 'medium';
  static const String priorityHigh = 'high';

  // Dialog Constants
  static const String dialogConfirm = 'Confirm';
  static const String dialogCancel = 'Cancel';
  static const String dialogDelete = 'Delete';
  static const String dialogSave = 'Save';
  static const String dialogClose = 'Close';

  // Message Constants
  static const String messageTaskCreated = 'Task created successfully';
  static const String messageTaskUpdated = 'Task updated successfully';
  static const String messageTaskDeleted = 'Task deleted successfully';
  static const String messageNoTasks = 'No tasks found';
  static const String messageNoConnection = 'No internet connection';
  static const String messageServerError = 'Server error occurred';
  static const String messageDeleteConfirm =
      'Are you sure you want to delete this task?';

  // Route Names
  static const String routeHome = '/';
  static const String routeTaskList = '/tasks';
  static const String routeTaskDetail = '/task-detail';
  static const String routeTaskForm = '/task-form';
  static const String routeTaskCreate = '/task-create';
  static const String routeTaskEdit = '/task-edit';
  static const String routeDebug = '/debug';

  // Preferences Keys
  static const String prefThemeMode = 'theme_mode';
  static const String prefApiUrl = 'api_url';
  static const String prefUsername = 'username';

  // Animation Durations
  static const int animationDurationShort = 200;
  static const int animationDurationMedium = 300;
  static const int animationDurationLong = 500;

  // Spacing Constants
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;

  // Border Radius Constants
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;
  static const double borderRadiusXLarge = 16.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 18.0;
  static const double fontSizeXXLarge = 20.0;

  // Max Length Constants
  static const int maxTitleLength = 100;
  static const int maxDescriptionLength = 500;
  static const int maxSearchLength = 50;

  // Validation Messages
  static const String validationRequired = 'This field is required';
  static const String validationTitleTooLong = 'Title is too long';
  static const String validationDescriptionTooLong = 'Description is too long';
  static const String validationInvalidEmail = 'Invalid email format';

  // Loading States
  static const String loadingTasks = 'Loading tasks...';
  static const String loadingTask = 'Loading task...';
  static const String savingTask = 'Saving task...';
  static const String deletingTask = 'Deleting task...';
  static const String refreshingTasks = 'Refreshing tasks...';
}
