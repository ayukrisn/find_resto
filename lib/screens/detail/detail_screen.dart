import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            SizedBox(
                width: double.infinity,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    maxHeight: 400, // Set your desired maximum height
                  ),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      'https://restaurant-api.dicoding.dev/images/large/43',
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 280),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30))),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Melting Pot",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 28,
                            color: Colors.amber,
                          ),
                          const SizedBox.square(
                            dimension: 8,
                          ),
                          Text(
                            "4.3",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                          "Jln. Pandeglang no 19, Medan",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Kategori",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    spacing: 2,
                    children: [
                      CategoryCard(category: "Italia"),
                      CategoryCard(category: "Modern"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Deskripsi",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ReadMoreText(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas et ullamcorper leo. Integer scelerisque vehicula tortor, vitae fringilla ipsum molestie at. Donec ut accumsan purus. Pellentesque a facilisis velit. Maecenas rhoncus non nulla ut faucibus. Sed vehicula sit amet odio condimentum sagittis. Vestibulum tempor neque id tellus placerat bibendum. Donec dictum massa eu libero fringilla euismod. Pellentesque venenatis posuere metus in finibus. Pellentesque id ultricies dui. Curabitur dictum, ligula eu ultrices aliquam, nisl mauris convallis eros, ac viverra arcu turpis vitae dui. Sed vitae sapien risus. Fusce volutpat est eget sem iaculis tempus. Mauris ut ante sollicitudin, gravida lacus non, accumsan ante. Aliquam erat volutpat. Vivamus porttitor in ipsum at sollicitudin. Donec vitae diam enim. Vestibulum convallis leo vitae odio sodales finibus. Mauris dictum vitae nisl ac convallis. Aliquam nulla lectus, maximus vitae purus et, tempor condimentum est. Donec sit amet neque sem. Sed tellus purus, tempus et eros sed, efficitur auctor risus. Donec feugiat dolor nec mi viverra fermentum. Nulla dignissim dolor non massa aliquam, sit amet hendrerit elit ullamcorper. Nunc vitae erat consequat, consectetur felis ut, viverra ante. Integer quis enim bibendum, dapibus neque sit amet, volutpat ligula. Cras scelerisque a erat vel congue. Maecenas eleifend ipsum convallis ligula lacinia condimentum. Suspendisse potenti.',
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Lihat selengkapnya',
                    trimExpandedText: 'Lihat ringkasan',
                    moreStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                    lessStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Makanan",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FoodCard(name: "Paket rosemary"),
                          FoodCard(name: "Toastie salmon"),
                        ],
                      )),
                  const SizedBox(height: 24),
                  Text(
                    "Minuman",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          FoodCard(name: "Es Jeruk"),
                          FoodCard(name: "Sirup Marjan"),
                        ],
                      )),
                  const SizedBox(height: 24),
                  Text(
                    "Review dan Rating",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  RatingCard(),
                  const SizedBox(height: 6),
                  RatingCard()
                ],
              ),
            )
          ]),
        ],
      ),
    ));
  }
}

class RatingCard extends StatelessWidget {
  const RatingCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Theme.of(context)
          .colorScheme
          .primary
          .withOpacity(0.1), // Add some elevation for shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Background color of the circle
                      shape: BoxShape.circle, // Makes the container circular
                    ),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ikbal",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        "12 Januari 2019",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              indent: 4,
              endIndent: 4,
            ),
            Text("Makanan dengan lauk yang enak",
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final String name;

  const FoodCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 4,
      shadowColor: Theme.of(context)
          .colorScheme
          .primary
          .withOpacity(0.1), // Add some elevation for shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 124,
              maxHeight: 164, // Set your desired maximum height
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  'https://restaurant-api.dicoding.dev/images/large/43',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black),
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12), bottom: Radius.circular(16))),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Text(
                      "Makanan dengan lauk yang enak",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.2),
      color: Theme.of(context).colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Text(
          category,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
