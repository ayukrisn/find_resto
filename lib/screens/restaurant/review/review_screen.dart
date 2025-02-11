import 'package:find_resto/screens/utils/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:find_resto/provider/restaurant/add_review_provider.dart';
import 'package:find_resto/static/add_review_result_state.dart';
import 'package:find_resto/static/navigation_route.dart';

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

  late FocusNode name;
  late FocusNode review;

  final isValid = ValueNotifier(false);
  final isVisible = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    name = FocusNode();
    review = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    review.dispose();
    _nameController.dispose();
    _reviewController.dispose();
  }

  String? get errorName {
    final text = _nameController.value.text;
    if (text.isEmpty) {
      return 'Nama tidak boleh kosong.';
    }
    return null;
  }

  String? get errorReview {
    final text = _reviewController.value.text;
    if (text.isEmpty) {
      return 'Review tidak boleh kosong.';
    } else if (text.length < 5) {
      return 'Review minimal terdiri dari 5 huruf.';
    }
    return null;
  }

  bool isValided() {
    if (errorName != null || errorReview != null) {
      return false;
    }
    return true;
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
                  ValueListenableBuilder(
                      valueListenable: _nameController,
                      builder: (context, v, _) {
                        return TextFormField(
                          autofocus: true,
                          focusNode: name,
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nama',
                            errorText: name.hasFocus ? errorName : null,
                          ),
                          onChanged: (_) {
                            isValid.value = isValided();
                          },
                          onFieldSubmitted: (_) {
                            name.unfocus();
                            FocusScope.of(context).requestFocus(review);
                          },
                        );
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  ValueListenableBuilder(
                    valueListenable: _reviewController,
                    builder: (context, v, _) {
                      return TextFormField(
                        autofocus: true,
                        focusNode: review,
                        controller: _reviewController,
                        minLines: 1,
                        maxLines: null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Review',
                          errorText: review.hasFocus ? errorReview : null,
                        ),
                        onChanged: (_) {
                          isValid.value = isValided();
                        },
                        onFieldSubmitted: (_) {
                          review.unfocus();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder(
                  valueListenable: isValid,
                  builder: (context, isEnabled, _) {
                    return ElevatedButton(
                        onPressed: isValid.value
                            ? () async {
                                await addReviewProvider.addReview(
                                  restaurantId: widget.restaurant['id'],
                                  name: _nameController.text,
                                  review: _reviewController.text,
                                );
                                if (addReviewProvider.resultState
                                    is AddReviewDoneState) {
                                  alertDialogWidget(
                                    context,
                                    title: "Review sudah dikirim!",
                                    content:
                                        "Terima kasih atas reviewmu yang berharga",
                                    onConfirm: () => {
                                      // Navigator.pop(context),
                                      Navigator.popUntil(
                                        context,
                                        ModalRoute.withName(
                                          NavigationRoute.detailRoute.name,
                                        ),
                                      )
                                      // Navigator.pushReplacementNamed(
                                      //   context,
                                      //   NavigationRoute.detailRoute.name,
                                      //   arguments: widget.restaurant['id'],
                                      // ),
                                    },
                                  );
                                } else if (addReviewProvider.resultState
                                    is AddReviewErrorState) {
                                  final errorMessage = (addReviewProvider
                                          .resultState as AddReviewErrorState)
                                      .error;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Review gagal ditambahkan. Error: $errorMessage')),
                                  );
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text("Kirim Review"));
                  }),
            ),
            if (addReviewProvider.resultState is AddReviewLoadingState)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
