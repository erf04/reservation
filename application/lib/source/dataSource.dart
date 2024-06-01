abstract class DataSource<T> {
  Future<T> reserveMeal(int shiftMealId, String token);

  Future<List<T>> getAllReservation(String token);

  Future<List<T>> filter(String token,
      [String date,
      String shiftName,
      String foodName1,
      String foodName2,
      String foodType,
      String dailyMeal]);

  Future<dynamic> getShiftMealCreation(String token);

  Future<T> creatShiftMeal(String token, String shiftName, String date, int mealId);

  //Future<dynamic> getMealCreation(String token);

  //Future<T> creatMeal(String token, String shiftName, String date, int mealId);
}
