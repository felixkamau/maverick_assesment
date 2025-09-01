import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:maverick/models/group.dart';
import 'package:maverick/models/members.dart';
import 'package:maverick/widgets/button.dart';
import 'package:maverick/widgets/not_found.dart';

class GroupDetails extends StatefulWidget {
  final GroupModel group;
  const GroupDetails({super.key, required this.group});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final membersBox = Hive.box<MemberModel>('members');
  final _memberNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isLoading = false;

  void _addMemberModel() async {
    final messenger = ScaffoldMessenger.of(context);
    final modalFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(15)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white24,

          child: Form(
            key: modalFormKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Modal BottomSheet'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _memberNameController,
                    decoration: _buildInputDecoration("Name member"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter member name";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: const TextInputType.numberWithOptions(),
                    decoration: _buildInputDecoration("Phone number"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : button(
                          buttonTxt: "Add member",
                          buttonW: double.infinity,
                          onPressed: () async {
                            if (modalFormKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                final memberName = _memberNameController.text
                                    .trim();
                                final phoneNo = _phoneNumberController.text;

                                await membersBox.add(
                                  MemberModel(
                                    id: DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                    groupId: widget.group.id,
                                    name: memberName,
                                    phoneNumber: phoneNo,
                                    groupName: widget.group.name,
                                    totalContributions: 0,
                                  ),
                                );

                                //Clear controllers
                                _phoneNumberController.clear();
                                _memberNameController.clear();

                                //Close modal
                                if (!mounted) return;
                                Navigator.pop(context);

                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Member added successfully'),
                                  ),
                                );
                              } catch (e) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text('Error adding member: $e'),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          buttonTxtStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          buttonColor: Color.fromRGBO(255, 144, 94, 1),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _memberNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.group.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // CTA tabs
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabsCTA(
                    tabTitle: Text(textAlign: TextAlign.center, "add"),
                  ),
                  _buildTabsCTA(
                    tabTitle: Text(textAlign: TextAlign.center, "add"),
                  ),
                  _buildTabsCTA(
                    tabTitle: Text(textAlign: TextAlign.center, "add"),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              // details container
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1.5, color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group id: ${widget.group.id}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(thickness: 2),
                      Text(
                        "Number of members: ${widget.group.numberOfMembers}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(thickness: 2),
                      Text(
                        "Group type: ${widget.group.groupType}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const Divider(thickness: 2),
                      Text(
                        "Contribution Amount: ${widget.group.contributionAmount}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),

                      const Divider(thickness: 2),
                      Text(
                        "Contribution Freq: ${widget.group.contributionFrequency}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //add Members button
              button(
                buttonW: double.infinity,
                buttonTxt: "Add Members",
                onPressed: () {
                  _addMemberModel();
                },
                buttonTxtStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
                buttonColor: Color.fromRGBO(255, 144, 94, 1),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Group Members",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 5),

              /// [member] list on listenable from out local Hive model
              _buildMemberList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberList() {
    return ValueListenableBuilder(
      valueListenable: membersBox.listenable(),
      builder: (context, Box<MemberModel> memberBx, _) {
        // Filter members by group id
        final groupMembers = memberBx.values
            .where((member) => member.groupId == widget.group.id)
            .toList();

        if (groupMembers.isEmpty) {
          return notFound(
            context: context,
            assetImg: 'assets/animations/notfound.json',
            text: "No members found",
          );
        }

        // final members = memberBx.values.toList();
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (_, _) => Divider(color: Colors.grey),
          itemCount: groupMembers.length,
          itemBuilder: (context, index) {
            final member = groupMembers[index];
            return ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text(member.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.groupName),
                  Text(
                    "GroupID: ${member.groupId}",
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTabsCTA({required Text tabTitle}) {
    return Container(
      width: 100,
      height: 45,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 144, 94, 0.8),
        border: Border.all(width: 1, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: tabTitle),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 2,
          color: Color.fromRGBO(255, 144, 94, 1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
