import 'package:find_resto/data/model/restaurant_detail_response.dart';
import 'package:find_resto/screens/error/error_screen.dart';
import 'package:find_resto/static/navigation_route.dart';
import 'package:find_resto/static/restaurant_detail_result_state.dart';
import 'package:find_resto/provider/restaurant_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .getRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantDetailLoadedState(data: var restaurantDetail) =>
              BodyOfDetailScreenWidget(
                statusBarHeight: statusBarHeight,
                restaurantDetail: restaurantDetail,
              ),
            RestaurantDetailErrorState(error: var message) => Center(
                child: ErrorScreen(message: message)
              ),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}

class BodyOfDetailScreenWidget extends StatelessWidget {
  final RestaurantDetail restaurantDetail;
  final double statusBarHeight;

  const BodyOfDetailScreenWidget(
      {super.key,
      required this.restaurantDetail,
      required this.statusBarHeight});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    child: Hero(
                      tag: restaurantDetail.pictureId,
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/large/${restaurantDetail.pictureId}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
            Positioned(
              top: 16 + statusBarHeight,
              left: 16,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.onSurface,
                    )),
              ),
            ),
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
                        restaurantDetail.name,
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
                            restaurantDetail.rating.toString(),
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
                          "${restaurantDetail.address}, ${restaurantDetail.city}",
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
                  SizedBox(
                    height: 36,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurantDetail.categories.length,
                        itemBuilder: (context, index) {
                          final category = restaurantDetail.categories[index];

                          return CategoryCard(category: category.name);
                        }),
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
                    restaurantDetail.description,
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
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 124,
                      maxHeight: 164, // Set your desired maximum height
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurantDetail.menus.foods.length,
                        itemBuilder: (context, index) {
                          final food = restaurantDetail.menus.foods[index];

                          return FoodCard(name: food.name);
                        }),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Minuman",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 124,
                      maxHeight: 164, // Set your desired maximum height
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: restaurantDetail.menus.drinks.length,
                        itemBuilder: (context, index) {
                          final drink = restaurantDetail.menus.drinks[index];

                          return FoodCard(name: drink.name);
                        }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Review dan Rating",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () async {
                            final bool? shouldRefresh =
                                await Navigator.pushNamed(context,
                                    NavigationRoute.addReviewRoute.name,
                                    arguments: {
                                  'id': restaurantDetail.id,
                                  'name': restaurantDetail.name
                                }) as bool?;

                            if (shouldRefresh ?? false) {
                              context.read<RestaurantDetailProvider>().getRestaurantDetail(restaurantDetail.id);
                            }
                          },
                          child: Text("Tambahkan Review"))
                    ],
                  ),
                  // const SizedBox(height: 12),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 4),
                      scrollDirection: Axis.vertical,
                      itemCount: restaurantDetail.customerReviews.length,
                      itemBuilder: (context, index) {
                        final review = restaurantDetail.customerReviews[index];

                        return RatingCard(review: review);
                      }),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}

class RatingCard extends StatelessWidget {
  final CustomerReview review;

  const RatingCard({super.key, required this.review});

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
                      review.name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Text(
                        review.date,
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
            Text(review.review, style: Theme.of(context).textTheme.titleMedium),
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
                child: Image.asset(
                  'assets/images/restaurant.jpeg',
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
