
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/models/salon/salon_model.dart';

class AccountVerificationScreen extends StatefulWidget {
  @override
  _AccountVerificationScreenState createState() =>
      _AccountVerificationScreenState();
}

class _AccountVerificationScreenState extends State<AccountVerificationScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Verification',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('salons')
                          .where('isApproved', isEqualTo: selectedIndex == 1)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No records found'));
                        }
                        return DataTable(
                          columnSpacing: 22,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  spreadRadius: 2),
                            ],
                          ),
                          columns: [
                            DataColumn(label: Text('Salon Name')),
                            DataColumn(label: Text('Owner Name')),
                            DataColumn(label: Text('Phone')),
                            DataColumn(label: Text('ID Card')),
                            DataColumn(label: Text('Business License')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Action')),
                          ],
                          rows: snapshot.data!.docs.map((doc) {
                            Salon salon = Salon.fromJson(
                                doc.data() as Map<String, dynamic>);
                            return DataRow(cells: [
                              DataCell(Text(salon.businessName ?? "")),
                              DataCell(Text(salon.ownerName ?? "")),
                              DataCell(Text(salon.phoneNumber ?? "")),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Image.network(
                                          salon.idProofUrl!,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Text(error.toString());
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View file',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                TextButton(
                                  onPressed: () {
                                    print(salon.idProofUrl);
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: Image.network(
                                          salon.idProofUrl!,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Text('Failed to load image');
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View file',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: salon.isApproved!
                                        ? Colors.green
                                        : Colors.orange,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    salon.isApproved! ? 'Approved' : 'Pending',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataCell(salon.isApproved!
                                  ? SizedBox()
                                  : ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('salons')
                                            .doc(salon.uid)
                                            .update({'isApproved': true});
                                      },
                                      child: Text('Approve',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                    )),
                            ]);
                          }).toList(),
                        );
                      },
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
