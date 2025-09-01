import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maverick/models/group.dart';
import 'package:maverick/models/members.dart';
import 'package:maverick/models/transaction.dart';
import 'package:maverick/screens/create_group.dart';
import 'package:maverick/screens/group_details.dart';
import 'package:maverick/screens/groups.dart';
import 'package:maverick/services/auth_service.dart';
import 'package:maverick/widgets/not_found.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  void _clearHive() {
    var box1 = Hive.box<GroupModel>('groups');
    var box2 = Hive.box<TransactionModel>('transactions');
    var box3 = Hive.box<MemberModel>('members');

    box1.clear();
    box2.clear();
    box3.clear();
  }

  @override
  Widget build(BuildContext context) {
    final groupsBox = Hive.box<GroupModel>('groups');
    final membersBox = Hive.box<MemberModel>('members');
    final transactionsBox = Hive.box<TransactionModel>('transactions');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Icon(Icons.settings, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(255, 144, 94, 0.2),
                    child: Icon(
                      Icons.person,
                      color: Color.fromRGBO(255, 144, 94, 1),
                      size: 28,
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      Text(
                        "Manage your groups",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Statistics Cards
              ValueListenableBuilder(
                valueListenable: groupsBox.listenable(),
                builder: (context, Box<GroupModel> groups, _) {
                  return ValueListenableBuilder(
                    valueListenable: membersBox.listenable(),
                    builder: (context, Box<MemberModel> members, _) {
                      final totalGroups = groups.length;
                      final totalMembers = members.length;
                      final activeGroups = groups.values
                          .where((g) => g.numberOfMembers > 0)
                          .length;

                      return Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              title: "Total Groups",
                              value: totalGroups.toString(),
                              icon: Icons.group_work,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: "Total Members",
                              value: totalMembers.toString(),
                              icon: Icons.people,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              title: "Active Groups",
                              value: activeGroups.toString(),
                              icon: Icons.trending_up,
                              color: Color.fromRGBO(255, 144, 94, 1),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),

              SizedBox(height: 24),

              // Search Bar
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

              SizedBox(height: 24),

              // Quick Actions
              Row(
                children: [
                  Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Spacer(),
                  // Debug buttons Sections
                  TextButton(
                    onPressed: AuthService().logOut,
                    child: Text("Logout", style: TextStyle(fontSize: 12)),
                  ),
                  TextButton(
                    onPressed: _clearHive,
                    child: Text("Clear", style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildQuickActionCard(
                      title: "Create Group",
                      icon: Icons.add_circle,
                      color: Color.fromRGBO(255, 144, 94, 1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateGroup(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildQuickActionCard(
                      title: "Add Member",
                      icon: Icons.person_add,
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Groups()),
                        );
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              // Groups Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your Groups",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Groups List
              ValueListenableBuilder(
                valueListenable: groupsBox.listenable(),
                builder: (context, Box<GroupModel> box, _) {
                  if (box.isEmpty) {
                    return notFound(
                      context: context,
                      assetImg: 'assets/animations/notfound.json',
                      text: "No Groups found",
                    );
                  }

                  final groups = box.values
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
                    return Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          "No groups match your search",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[800],
              ),
            ),
          ],
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
