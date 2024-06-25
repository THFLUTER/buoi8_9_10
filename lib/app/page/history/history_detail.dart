import 'package:app_api/app/model/bill.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryDetail extends StatelessWidget {
  final List<BillDetailModel> bill;

  const HistoryDetail({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết hóa đơn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        // Use SingleChildScrollView for scrollable content
        padding: const EdgeInsets.all(16.0), // Add padding for better spacing
        child: Column(
          children: [
            // Bill details list
            ListView.separated(
              shrinkWrap:
                  true, // Prevent list view from expanding unnecessarily
              physics:
                  const NeverScrollableScrollPhysics(), // Disable list scrolling
              itemCount: bill.length,
              separatorBuilder: (context, index) =>
                  const Divider(thickness: 1.0), // Separator
              itemBuilder: (context, index) {
                var data = bill[index];
                return _buildBillItem(data);
              },
            ),

            // Total amount section (optional)
            if (bill.isNotEmpty) // Check if there are any bill items
              Column(
                children: [
                  const SizedBox(height: 16.0), // Spacing between sections
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tổng tiền:',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat('#,##0₫').format(bill.fold(
                            0,
                            (sum, item) =>
                                sum +
                                item.price *
                                    item.count)), // Calculate total price
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillItem(BillDetailModel data) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: 60.0, // Adjust image height as needed
            width: 60.0, // Adjust image width as needed
            child: data.imageUrl.isNotEmpty
                ? Image.network(data.imageUrl, fit: BoxFit.cover)
                : const Center(
                    child: Text('No Image'),
                  ),
          ),
        ),
        const SizedBox(width: 16.0), // Spacing between image and details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.productName,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Số lượng: ${data.count}',
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Giá: ${NumberFormat('#,##0₫').format(data.price)}',
                style: const TextStyle(fontSize: 14.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
