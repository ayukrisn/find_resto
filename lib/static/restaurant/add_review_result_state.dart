sealed class AddReviewResultState {}

class AddReviewNoneState extends AddReviewResultState {}

class AddReviewLoadingState extends AddReviewResultState {}

class AddReviewErrorState extends AddReviewResultState {
  final String error;
  AddReviewErrorState(this.error);
}

class AddReviewDoneState extends AddReviewResultState {
  final String message;

  AddReviewDoneState(this.message);
}