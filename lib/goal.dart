class Goal {
  String id;
  String name;
  String description;
  DateTime? startDate;
  DateTime? endDate;
  List<String> subGoals;

  Goal({required this.id, required this.name, this.description = '', this.startDate, this.endDate, this.subGoals = const []});
}
