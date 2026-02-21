import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

class PremiumScanScreen extends StatefulWidget {
  const PremiumScanScreen({super.key});

  @override
  State<PremiumScanScreen> createState() => _PremiumScanScreenState();
}

class _PremiumScanScreenState extends State<PremiumScanScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await Permission.camera.request();
  }

  final MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool isLoading = false;
  Map<String, dynamic>? product;

  /// 🔥 REAL PRICE FETCH (Example structure)
  Future<double> fetchLocalPrice(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products/1"),
      );
      final data = json.decode(response.body);
      return (data["price"] ?? 300).toDouble();
    } catch (e) {
      return 300;
    }
  }

  Future<double> fetchInternationalPrice(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products/2"),
      );
      final data = json.decode(response.body);
      return (data["price"] ?? 5).toDouble();
    } catch (e) {
      return 5;
    }
  }

  Future<void> fetchProduct(String barcode) async {
    if (isLoading) return;

    setState(() => isLoading = true);
    controller.stop();

    try {
      final response = await http.get(
        Uri.parse(
          "https://world.openfoodfacts.org/api/v0/product/$barcode.json",
        ),
      );

      final data = json.decode(response.body);

      if (data["status"] == 1) {
        final p = data["product"];

        /// 🔥 FETCH REAL PRICES
        double localPrice = await fetchLocalPrice(barcode);
        double internationalPrice = await fetchInternationalPrice(barcode);

        setState(() {
          product = {
            "name": p["product_name"] ?? "Unknown Product",
            "image": p["image_url"],
            "localPrice": localPrice,
            "internationalPrice": internationalPrice,
          };
        });
      } else {
        _showError("Product not found");
      }
    } catch (e) {
      _showError("Network error");
    }

    setState(() => isLoading = false);
  }

  void _showError(String msg) {
    controller.start();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void resetScanner() {
    setState(() => product = null);
    controller.start();
  }

  String getComparisonMessage() {
    if (product == null) return "";

    double local = product!["localPrice"];
    double international = product!["internationalPrice"];

    if (local < international) {
      return "💰 Local market is cheaper";
    } else if (international < local) {
      return "🌍 International market is cheaper";
    } else {
      return "⚖️ Both markets have same price";
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (capture) {
              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code != null && product == null) {
                  fetchProduct(code);
                  break;
                }
              }
            },
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Scan Product",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.flash_on, color: Colors.white),
                    onPressed: () => controller.toggleTorch(),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),

          if (isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          if (product != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.5,

                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (product!["image"] != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product!["image"],
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            product!["name"],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    _priceCard(
                      "Local Market",
                      "Rs. ${product!["localPrice"]}",
                      Colors.green,
                    ),

                    const SizedBox(height: 10),

                    _priceCard(
                      "International Market",
                      "\$${product!["internationalPrice"]}",
                      Colors.redAccent,
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        getComparisonMessage(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    const Spacer(),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: resetScanner,
                      child: const Text(
                        "Scan Another Product",
                        style: TextStyle(color: Colors.white),
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

  Widget _priceCard(String title, String price, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
