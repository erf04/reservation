from django.urls import path
from . import views
urlpatterns = [
    path('get-menu/',views.ReservationView.as_view()),
    path('get-reservations/',views.get_all_reservations),
    path('reserve/',views.reserve_meal),
    path('shiftmeal/create/',views.ShiftMealAPIView.as_view()),
    path('meal/create/',views.MealAPIView.as_view()),
    path('profile/',views.ProfileAPIView.as_view()),
    path('email/',views.send_test_email),
    path('delete-reservation/<int:id>/',views.delete_reservation),
    path('pending-list/',views.get_pending_reservations),
    path('sms/',views.send_sms),
    path('password/reset/',views.PasswordResetRequestView.as_view()),
    path('password/reset/confirm/',views.PasswordResetConfirmView.as_view()),
]