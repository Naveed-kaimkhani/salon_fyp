import 'package:flutter/material.dart';

class DataTableExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DataTable Example')),
      body: Center(
        child: DataTable(
          columns: [
            DataColumn(label: Text('File')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        content: Image.network(
                          'https://your-image-url.com/image.jpg',
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
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
            ]),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: DataTableExample()));
}
