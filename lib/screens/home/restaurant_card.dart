import 'package:find_resto/data/model/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantCard({
    super.key,
    required this.restaurant
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
                            restaurant.rating.toString(),
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
                    restaurant.name,
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
                              restaurant.city,
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
                      restaurant.description,
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
