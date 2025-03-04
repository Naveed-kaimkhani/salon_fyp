import 'package:flutter/material.dart';
import 'package:hair_salon/constants/constants.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  int selectedIndex = 0;

  // final List<Map<String, String>> accounts = [
  //   {
  //     'salonName': 'Luxury Salon',
  //     'idCard': 'View file',
  //     'businessLicense': 'View file',
  //     'status': 'Pending',
  //     'submissionDate': '12/05/2024'
  //   },
  //   {
  //     'salonName': 'Elite Spa',
  //     'idCard': 'View file',
  //     'businessLicense': 'View file',
  //     'status': 'Approved',
  //     'submissionDate': '10/11/2023'
  //   },
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Verification',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.purple,
        elevation: 5,
        shadowColor: Colors.black54,
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            selectedIconTheme: IconThemeData(color: Colors.white, size: 30),
            backgroundColor: Colors.grey.shade200,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.hourglass_empty, color: Colors.grey.shade700),
                selectedIcon:
                    Icon(Icons.hourglass_full, color: AppColors.purple),
                label: Text('Pending Approval'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.check_circle_outline,
                    color: Colors.grey.shade700),
                selectedIcon: Icon(Icons.check_circle, color: AppColors.purple),
                label: Text('Approved'),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedIndex == 0
                            ? 'Pending Verification'
                            : 'Approved Accounts',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.purple),
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: () {},
                      //   icon: Icon(Icons.download, color: Colors.white),
                      //   label: Text('Export Report'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.purple,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10)),
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: 16, vertical: 10),
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: DataTable(
                        key: ValueKey<int>(selectedIndex),
                        columnSpacing: 22,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        columns: [
                          DataColumn(
                              label: Text('Salon Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('ID Card',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Business License',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(
                              label: Text('Submission Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          // DataColumn(
                          //     label: Text('Action',
                          //         style:
                          //             TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: accounts
                            .where((account) => selectedIndex == 0
                                ? account['status'] == 'Pending'
                                : account['status'] == 'Approved')
                            .map(
                              (account) => DataRow(cells: [
                                DataCell(Text(account['salonName']!)),
                                DataCell(Text(account['idCard']!,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500))),
                                DataCell(Text(account['businessLicense']!,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500))),
                                DataCell(
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: account['status'] == 'Pending'
                                          ? Colors.orange
                                          : Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      account['status']!,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                DataCell(Text(account['submissionDate']!)),
                                // DataCell(ElevatedButton(
                                //   onPressed: () {},
                                //   child: Text('Send Message'),
                                //   style: ElevatedButton.styleFrom(
                                //     backgroundColor: Colors.blue,
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(8)),
                                //     padding: EdgeInsets.symmetric(
                                //         horizontal: 12, vertical: 8),
                                //   ),
                                // )),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
