import 'package:find_resto/provider/review/add_review_provider.dart';
import 'package:find_resto/static/add_review_result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewScreen extends StatefulWidget {
  final Map restaurant;

  const ReviewScreen({super.key, required this.restaurant});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addReviewProvider = Provider.of<AddReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface,
            )),
        title: Text("Berikan Review"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 28,
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Berikan review untuk ${widget.restaurant['name']}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text("Bagaimana pengalamanmu di restoran ini?",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Tolong masukkan namamu'
                        : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: _reviewController,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Tolong masukkan reviewmu'
                        : null,
                    minLines: 1,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Review',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await addReviewProvider.addReview(
                        restaurantId: widget.restaurant['id'],
                        name: _nameController.text,
                        review: _reviewController.text,
                      );

                      if (addReviewProvider.resultState is AddReviewDoneState) {
                        // AlertDialog(
                        //   title: Text("Berhasil!"),
                        //   content: Text(
                        //       "Reviewmu sudah ditambahkan. Terima kasih atas pendapatmu yang berharga."),
                        //   actions: [
                        //     TextButton(onPressed: () {

                        //     }, child: Text("Kembali"))
                        //   ],
                        // );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Review berhasil ditambahkan!')),
                        );
                      } else if (addReviewProvider.resultState
                          is AddReviewErrorState) {
                        final errorMessage = (addReviewProvider.resultState
                                as AddReviewErrorState)
                            .error;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $errorMessage')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text("Kirim Review")),
            ),
            if (addReviewProvider.resultState is AddReviewLoadingState)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
