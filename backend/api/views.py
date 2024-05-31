from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework import permissions
from .serializers import MealSerializer,ShiftMealSerializer
from rest_framework.decorators import api_view,permission_classes
from .models import ShiftMeal,Meal,WorkFlow
import jdatetime


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def get_meals_by_date_and_shift(request:Request):
    date = request.data.get('date')
    shift_name = request.data.get('shift')
    if not date or not shift_name:
        return Response({"error": "date or shift is required."}, status=status.HTTP_400_BAD_REQUEST)
    jalali_date = jdatetime.date.fromisoformat(date)
    gregorian_date = jalali_date.togregorian()  
    meals = ShiftMeal.objects.filter(date=gregorian_date, shift__shift_name=shift_name)
    serialized=ShiftMealSerializer(meals,many=True)
    return Response(serialized.data,status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def get_all_reservations(requrest:Request):
    my_user=requrest.user
    shift_meals=ShiftMeal.objects.filter(shift__work_flows__user=my_user)
    serialized=ShiftMealSerializer(shift_meals,many=True)
    return Response(serialized.data)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def reserve_meal(request:Request):
    date = request.data.get('date')
    shift_name = request.data.get('shift')
    meal:dict = request.data.get('meal')
    if not date or not shift_name or not meal:
        return Response({"error": "date or shift or meal is required."}, status=status.HTTP_400_BAD_REQUEST)
    food=meal.get('food')
    type=meal.get('food_type')
    daily_meal=meal.get('daily_meal')
    if not food or not type or not daily_meal:
        return Response({"error": "food or type or daily_meal is required."}, status=status.HTTP_400_BAD_REQUEST)
    meal=Meal.objects.get_or_create(food=food,food_type=type,daily_meal=daily_meal)
    jalali_date = jdatetime.date.fromisoformat(date)
    gregorian_date = jalali_date.togregorian()
    shift_meal=ShiftMeal.objects.get(date=gregorian_date,meal=meal,shift__shift_name=shift_name)
    if shift_meal:
        work_flow,created=WorkFlow.objects.get_or_create(user=request.user,shift__name=shift_name)
        if not created:
            return Response({"error":"you have reserved this meal already"},status=status.HTTP_406_NOT_ACCEPTABLE)
        WorkFlowSerializer
        return Response()
        
    else:
        return Response(data={"error":f"no shiftMeal with date {date} and shift {shift_name}"},status=status.HTTP_204_NO_CONTENT)




