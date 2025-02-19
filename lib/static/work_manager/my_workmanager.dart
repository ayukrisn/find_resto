enum MyWorkmanager {
  // set the unique name and task name for one off and periodic work manager
  oneOff(
    "task-identifier",
    "task-identifier",
  ),
  periodic(
    "com.example.notification_practice",
    "com.example.notification_practice",
  );

  final String uniqueName;
  final String taskName;

  const MyWorkmanager(this.uniqueName, this.taskName);
}
