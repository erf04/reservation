from django.urls import path
from . import views
urlpatterns = [
    path('get-menu/',views.filter_meals),
    path('get-reservations/',views.get_all_reservations),
    path('reserve/',views.reserve_meal),
    path('shiftmeal/create/',views.ShiftMealAPIView.as_view()),
    path('meal/create/',views.MealAPIView.as_view()),
    path('profile/',views.ProfileAPIView.as_view()),
    path('email/',views.send_test_email),
    path('delete-reservation/<int:id>/',views.delete_reservation),
    path('pending-list/',views.get_pending_reservations)
]