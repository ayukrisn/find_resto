enum NavigationRoute {
 homeRoute("/"),
 searchRoute("/search"),
 detailRoute("/detail"),
 addReviewRoute("/detail/review");
 
 const NavigationRoute(this.name);
 final String name;
}