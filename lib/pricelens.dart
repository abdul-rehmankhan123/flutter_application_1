import 'package:flutter/material.dart';
import 'package:flutter_application_2/product.dart';

class PriceLensHomeScreen extends StatefulWidget {
  const PriceLensHomeScreen({super.key});

  @override
  State<PriceLensHomeScreen> createState() => _PriceLensHomeScreenState();
}

class _PriceLensHomeScreenState extends State<PriceLensHomeScreen> {
  String searchQuery = "";

  final List<Map<String, String>> products = [
    {"name": "Nestle Milo 390g", "price": "Rs. 370", "image": "assets/pic.jpg"},
    {
      "name": "Tide Detergent 2kg",
      "price": "Rs. 640",
      "image": "assets/pic1.jpg",
    },
    {
      "name": "Dove Shampoo 400ml",
      "price": "Rs. 490",
      "image": "assets/pic2.png",
    },
    {
      "name": "Sony Headphones",
      "price": "Rs. 2200",
      "image": "assets/pic3.jpg",
    },
    {"name": "Cooking Oil 1L", "price": "Rs. 510", "image": "assets/pic4.jpg"},
    {"name": "Milk Pack 1L", "price": "Rs. 165", "image": "assets/pic5.jpg"},
    {
      "name": "Surf Excel Powder",
      "price": "Rs. 590",
      "image": "assets/pic6.jpg",
    },
    {"name": "Pepsi", "price": "Rs. 990", "image": "assets/pic7.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((item) {
      return item["name"]!.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: Center(
          child: Text("PriceLens", style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SEARCH BAR
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: "Search for a product...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Popular Price Drops",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 12),

            // HORIZONTAL PRODUCTS
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Container(
                      width: 150,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.06),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              product["image"]!,
                              height: 90,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product["name"]!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product["price"]!,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  historyTile("Tide Detergent", "assets/pic1.jpg"),
                  historyTile("Dove Shampoo", "assets/pic2.png"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget historyTile(String name, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.06)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(image, height: 55, width: 55, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}
