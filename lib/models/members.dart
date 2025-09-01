import 'package:hive/hive.dart';

part "members.g.dart";

@HiveType(typeId: 2)
class MemberModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String groupId; // ref from group model

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String groupName; // ref from group model

  @HiveField(5)
  final int totalContributions;

  const MemberModel({
    required this.id,
    required this.groupId,
    required this.name,
    required this.phoneNumber,
    required this.groupName,
    required this.totalContributions,
  });
}
