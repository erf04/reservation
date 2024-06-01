from django.urls import path
from . import views
urlpatterns = [
    path('get-menu/',views.filter_meals),
    path('get-reservations/',views.get_all_reservations),
    path('reserve/',views.reserve_meal),
    path('shiftmeal/create/',views.ShiftMealAPIView.as_view()),
    path('meal/create/',views.MealAPIView.as_view())
]