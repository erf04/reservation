from rest_framework.serializers import ModelSerializer
from .models import Meal,ShiftMeal,Shift,Reservation,User,Food,FoodType,DailyMeal,Drink
from rest_framework import serializers


class FoodSerializer(ModelSerializer):
    class Meta:
        model = Food
        fields="__all__"


class DrinkSerializer(ModelSerializer):
    class Meta:
        model = Drink
        fields=('name',)

class MealSerializer(ModelSerializer):
    food=FoodSerializer(many=False)
    diet=FoodSerializer(many=False)
    dessert=FoodSerializer(many=False)
    drinks=DrinkSerializer(many=True)
    class Meta:
        model = Meal
        fields=('id','food','diet','dessert','daily_meal','drinks')



class ShiftSerializer(ModelSerializer):
    class Meta:
        model = Shift
        fields="__all__"


class ShiftMealSerializer(ModelSerializer):
    meal=MealSerializer(many=False)
    shift=ShiftSerializer(many=False)
    class Meta:
        model = ShiftMeal
        fields="__all__"


class UserSerializer(ModelSerializer):
    class Meta:
        model = User
        fields=('id','username','profile','is_supervisor',"is_shift_manager")
        ref_name="UserSerializer"


class ReservationSerializer(ModelSerializer):
    shift_meal=ShiftMealSerializer(many=False)
    user=UserSerializer(many=False)
    class Meta:
        model = Reservation
        fields=('id','user','shift_meal','date')





    

class CombinedMealShiftSerializer(serializers.Serializer):
    meals = MealSerializer(many=True)
    shifts = ShiftMealSerializer(many=True)



class CombinedFoodCreationSerializer(serializers.Serializer):
    foods=FoodSerializer(many=True)
    food_types = serializers.ListField(
        child=serializers.CharField(), 
        default=[food_type.label for food_type in FoodType]
    )
    daily_meals = serializers.ListField(
        child=serializers.CharField(),
        default=[daily_meal.label for daily_meal in DailyMeal]
    )
    






