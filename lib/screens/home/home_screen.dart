import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Find Resto")),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        itemCount: 15, // Number of times to display RestaurantCard
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: RestaurantCard(), // Create a RestaurantCard for each index
          );
        },
      ),
    );
  }
}

class RestaurantCard extends StatelessWidget {
  const RestaurantCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Color.fromARGB(255, 255, 251, 243),
      // margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 100,
                  minHeight: 80,
                  maxWidth: 160,
                  minWidth: 120,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'assets/images/restaurant.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  top: 4,
                  left: 4,
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox.square(
                            dimension: 2,
                          ),
                          Text(
                            "4.2",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ))
            ]),
            const SizedBox.square(dimension: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Melting Pot",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox.square(
                    dimension: 8,
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox.square(
                            dimension: 2,
                          ),
                          Opacity(
                            opacity: 0.5,
                            child: Text(
                              "Medan",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox.square(dimension: 12),
                  Opacity(
                    opacity: 0.3,
                    child: Text(
                      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. ...",
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2, // Set the maximum number of lines
                      overflow: TextOverflow
                          .ellipsis, // Add ellipsis (...) if the text overflows
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
