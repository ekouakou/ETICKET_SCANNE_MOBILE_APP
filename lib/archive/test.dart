




import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Change the background color of the entire page
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage('https://cdn.dribbble.com/userupload/10526059/file/original-4d88d569cb5457f31e1c6e9fb8a3beaf.png?resize=700x525&vertical=center'), // Your profile image URL
            ),
            SizedBox(width: 10),
            Text('Welcome back!\nFauzan Pradana', style: google_fonts.GoogleFonts.poppins(fontSize: 16)),
            Spacer(),
            Stack(
              children: [
                Icon(Icons.notifications, size: 30),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text('3', style: TextStyle(fontSize: 12, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of the container
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[200],
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search Drone',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.filter_list, size: 30),
                  ],
                ),
                SizedBox(height: 20),

                // Slider
                CarouselSlider(
                  items: [
                    // Example item
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage('https://cdn.dribbble.com/userupload/10526059/file/original-4d88d569cb5457f31e1c6e9fb8a3beaf.png?resize=700x525&vertical=center'), // Your image URL
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('DJI MINI 4 PRO', style: google_fonts.GoogleFonts.poppins(fontSize: 20, color: Colors.white)),
                              Text('Maximum Visual Impact with 4K/60fps HDR', style: google_fonts.GoogleFonts.poppins(fontSize: 16, color: Colors.white)),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('\$950.47 - Buy Now'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                  ),
                ),
                SizedBox(height: 20),

                // TabBar
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        tabs: [
                          Tab(text: 'All Brand'),
                          Tab(text: 'MIG Turbo'),
                          Tab(text: 'Mini Drone'),
                        ],
                      ),
                      SizedBox(
                        height: 200,
                        child: TabBarView(
                          children: [
                            // Tab content for All Brand
                            ListView(
                              children: [
                                ProductCard(name: 'DJI Inspire 3', price: 920.00, reviews: 26, rating: 4.6),
                                ProductCard(name: 'MIG Turbo', price: 890.00, reviews: 28, rating: 4.8),
                              ],
                            ),
                            // Tab content for MIG Turbo
                            ListView(
                              children: [
                                ProductCard(name: 'MIG Turbo', price: 890.00, reviews: 28, rating: 4.8),
                              ],
                            ),
                            // Tab content for Mini Drone
                            ListView(
                              children: [
                                ProductCard(name: 'DJI Mini 2', price: 500.00, reviews: 15, rating: 4.5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home), onPressed: () {}),
            IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
            SizedBox(width: 40), // The dummy child for the QR code button space
            IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
            IconButton(icon: Icon(Icons.person), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to QR code scanning
        },
        child: Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final int reviews;
  final double rating;

  const ProductCard({
    required this.name,
    required this.price,
    required this.reviews,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network('https://cdn.dribbble.com/userupload/10526059/file/original-4d88d569cb5457f31e1c6e9fb8a3beaf.png?resize=700x525&vertical=center'), // Your image URL
        title: Text(name, style: google_fonts.GoogleFonts.poppins(fontSize: 16)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$$price CAD', style: google_fonts.GoogleFonts.poppins(fontSize: 14)),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 16),
                Text('$rating ($reviews reviews)', style: google_fonts.GoogleFonts.poppins(fontSize: 12)),
              ],
            ),
          ],
        ),
        trailing: Icon(Icons.favorite_border),
      ),
    );
  }
}

