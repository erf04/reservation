from rest_framework.serializers import ModelSerializer
from .models import Meal,ShiftMeal,Shift,Reservation,User,Food,FoodType,DailyMeal,Drink,User
from rest_framework import serializers
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_decode
from django.utils.encoding import force_str
# from django.contrib.auth.models import User
from rest_framework import serializers
from rest_framework.exceptions import ValidationError

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
        fields=('id','username','email','profile','is_supervisor',"is_shift_manager")
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




class PasswordResetRequestSerializer(serializers.Serializer):
    email = serializers.EmailField()

    def validate_email(self, value):
        if not User.objects.filter(email=value).exists():
            raise ValidationError("This email address is not registered.")
        return value

class PasswordResetConfirmSerializer(serializers.Serializer):
    email = serializers.EmailField()
    code = serializers.CharField(max_length=6)
    new_password = serializers.CharField(min_length=8, write_only=True)

    def validate_email(self, value):
        """
        Check if the email exists in the database.
        """
        if not User.objects.filter(email=value).exists():
            raise serializers.ValidationError("This email is not registered.")
        return value

    def validate_new_password(self, value):
        """
        Check if the new password meets the criteria.
        """
        if len(value) < 8:
            raise serializers.ValidationError("Password must be at least 8 characters long.")
        # Add other password validations if needed (e.g., complexity, special characters)
        return value

    def validate(self, data):
        """
        Check if the code is correct for the provided email.
        """
        email = data.get('email')
        code = data.get('code')

        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            raise serializers.ValidationError("Invalid email or code.")

        if user.reset_code != code:
            raise serializers.ValidationError("Invalid email or code.")
        
        return data

    






