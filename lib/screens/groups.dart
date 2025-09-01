import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maverick/models/group.dart';
import 'package:maverick/screens/group_details.dart';
import 'package:maverick/widgets/not_found.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<GroupModel>('groups');

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Groups")),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search For u groups
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search groups...",
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<GroupModel> groupBox, _) {
                  if (groupBox.isEmpty) {
                    return notFound(
                      context: context,
                      assetImg: 'assets/animations/notfound.json',
                      text: "No Groups Found",
                    );
                  }

                  final groups = groupBox.values
                      .where(
                        (group) =>
                            _searchQuery.isEmpty ||
                            group.name.toLowerCase().contains(_searchQuery) ||
                            group.groupType.toLowerCase().contains(
                              _searchQuery,
                            ),
                      )
                      .toList();

                  if (groups.isEmpty) {
                    return Center(
                      child: notFound(
                        context: context,
                        assetImg: 'assets/animations/notfound.json',
                        text: "No Groups Found",
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final group = groups[index];
                      return _buildGroupCard(group, context);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(GroupModel group, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupDetails(group: group)),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 144, 94, 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.group,
                  color: Color.fromRGBO(255, 144, 94, 1),
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "${group.numberOfMembers} members • ${group.groupType}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "KSh ${group.contributionAmount.toStringAsFixed(0)} ${group.contributionFrequency}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
