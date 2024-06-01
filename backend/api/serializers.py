from rest_framework.serializers import ModelSerializer
from .models import Meal,ShiftMeal,Shift,WorkFlow,User
from rest_framework import serializers


class FoodSerializer(ModelSerializer):
    class Meta:
        model = Meal
        fields="__all__"

class MealSerializer(ModelSerializer):
    food1=FoodSerializer(many=False)
    food2=FoodSerializer(many=False)
    diet=FoodSerializer(many=False)
    dessert=FoodSerializer(many=False)
    class Meta:
        model = Meal
        fields="__all__"


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
        fields=('id','username','profile')
        ref_name="UserSerializer"


class WorkFlowSerializer(ModelSerializer):
    shift_meal=serializers.SerializerMethodField()
    user=UserSerializer(many=False)
    class Meta:
        model = WorkFlow
        fields=('id','user','shift_meal')

    def get_shift_meal(self,obj:WorkFlow):
        shift_meal=ShiftMeal.objects.get(shift__work_flows=obj)
        return ShiftMealSerializer(shift_meal,many=False).data
    

class CombinedSerializer(serializers.Serializer):
    meals = MealSerializer(many=True)
    shifts = ShiftMealSerializer(many=True)
    






