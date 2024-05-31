from rest_framework.serializers import ModelSerializer
from .models import Meal,ShiftMeal,Shift,WorkFlow
from rest_framework import serializers

class MealSerializer(ModelSerializer):
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


class WorkFlowSerializer(ModelSerializer):
    shift_meals=serializers.SerializerMethodField
    class Meta:
        model = WorkFlow
        fields=('id','user','shift','shift_meals')

    def get_shift_meals(self,obj:WorkFlow):
        shift_meals=ShiftMeal.objects.get(shift__workflows=obj)
        return ShiftMealSerializer(shift_meals,many=False).data



