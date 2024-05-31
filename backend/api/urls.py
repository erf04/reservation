from django.urls import path
from . import views
urlpatterns = [
    path('get-menu/',views.get_meals_by_date_and_shift),
    path('get-reservations/',views.get_all_reservations)
]