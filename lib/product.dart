import 'dart:ui';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, String> product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    String name = widget.product["name"]!;
    String price = widget.product["price"]!;
    String image = widget.product["image"]!;

    // Simple mock ingredients based on name
    List<String> ingredients;

    switch (name.toLowerCase()) {
      case "nestle milo 390g":
        ingredients = ["Chocolate", "Milk Powder", "Sugar"];
        break;
      case "tide detergent 2kg":
        ingredients = ["Detergent Powder"];
        break;
      case "dove shampoo 400ml":
        ingredients = ["Shampoo", "Fragrance", "Moisturizer"];
        break;
      case "sony headphones":
        ingredients = ["Headphone Unit", "Ear Cushions", "Wire/USB Cable"];
        break;
      case "cooking oil 1l":
        ingredients = ["Vegetable Oil"];
        break;
      case "milk pack 1l":
        ingredients = ["Milk"];
        break;
      case "surf excel powder":
        ingredients = ["Detergent Powder"];
        break;
      case "pepsi 500ml":
        ingredients = ["Carbonated Water", "Sugar", "Flavorings"];
        break;
      default:
        ingredients = ["Carbonated Water", "Sugar", "Flavorings"];
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: _bottomBar(price),
      body: CustomScrollView(
        slivers: [
          _headerImage(image),
          SliverToBoxAdapter(child: _productInfo(name, price, ingredients)),
        ],
      ),
    );
  }

  // 🔹 HEADER IMAGE WITH GRADIENT + BLUR
  Widget _headerImage(String image) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
              child: Image.asset(image, fit: BoxFit.cover),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.5), // soft dark overlay
                    Colors.black.withOpacity(0.1),
                  ],
                ),
              ),
            ),

            // Optional Blur for soft effect
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 PRODUCT INFO
  Widget _productInfo(String name, String price, List<String> ingredients) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  price,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Rating Row
          Row(
            children: const [
              Icon(Icons.star, color: Colors.amber, size: 20),
              SizedBox(width: 5),
              Text("4.8 Rating"),
              SizedBox(width: 10),
              Text("(1.1k Reviews)", style: TextStyle(color: Colors.grey)),
            ],
          ),

          const SizedBox(height: 20),

          // Description
          const Text(
            "Description",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            "A premium product carefully selected to meet your daily needs. High quality, reliable, and value for money.",
            style: TextStyle(color: Colors.grey.shade700, height: 1.6),
          ),

          const SizedBox(height: 18),

          // Ingredients
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: ingredients.map((e) => _chip(e)).toList(),
          ),

          const SizedBox(height: 25),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Quantity",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      onPressed: () => setState(() => quantity++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // 🔹 CHIP UI
  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  // 🔹 BOTTOM BAR
  Widget _bottomBar(String price) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          "Add to Cart - $price",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
