import 'package:flutter/material.dart';
import 'package:flutter_application_2/product.dart'; // ProductDetailPage import karo

class PriceLensHistoryScreen extends StatelessWidget {
  const PriceLensHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {
        "name": "Nestle Milo 390g",
        "price": "Rs. 370",
        "image": "assets/pic.jpg",
      },
      {
        "name": "Tide Detergent",
        "price": "Rs. 640",
        "image": "assets/pic2.png",
      },
      {
        "name": "LG Smart TV",
        "price": "Rs. 142,600",
        "image": "assets/pic3.jpg",
      },
      {"name": "Dove Shampoo", "price": "Rs. 490", "image": "assets/pic4.jpg"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("History"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(blurRadius: 8, color: Colors.black.withOpacity(0.06)),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item["image"]!,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["name"]!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["price"]!,
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Viewed recently",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to ProductDetailPage with product reference
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(product: item),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Detail",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
