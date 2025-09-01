import 'package:hive/hive.dart';
part 'group.g.dart';
/*
 - Hive models for group creation
 */

@HiveType(typeId: 0) // TypeAdapter
class GroupModel {
  @HiveField(0)
  final String id; // this will be referenced in members model

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int numberOfMembers;

  @HiveField(3)
  final String treasurer;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final String groupType;

  @HiveField(7)
  final double contributionAmount;

  @HiveField(8)
  final String contributionFrequency;

  @HiveField(9)
  final String meetingFrequency;

  @HiveField(10)
  final double groupBal;

  const GroupModel({
    required this.id,
    required this.groupType,
    required this.contributionAmount,
    required this.contributionFrequency,
    required this.meetingFrequency,
    required this.name,
    required this.numberOfMembers,
    required this.treasurer,
    required this.createdAt,
    required this.description,
    required this.groupBal
  });
}
