from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework import permissions
from .serializers import MealSerializer,ShiftMealSerializer,WorkFlowSerializer
from rest_framework.decorators import api_view,permission_classes
from .models import ShiftMeal,Meal,WorkFlow,Shift
import jdatetime


def ISO_to_gregorian(date:str):
    jalali_date = jdatetime.date.fromisoformat(date)
    gregorian_date = jalali_date.togregorian()  
    return gregorian_date

@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def filter_meals(request:Request):
    filters={}
    date = request.data.get('date')
    shift_name = request.data.get('shift')
    food1_name=request.data.get('food1-name')
    food2_name=request.data.get('food2-name')
    food_type=request.data.get('food-type')
    daily_meal=request.data.get('daily-meal')
    if date:
        gregorian_date=ISO_to_gregorian(date)
        filters["date"]=gregorian_date
    if shift_name:
        filters["shift__shift_name"]=shift_name
    if food1_name:
        filters["meal__food1__name"]=food1_name
    if food2_name:
        filters["meal__food2__name"]=food2_name
    if food_type:
        filters["meal__food_type"]=food_type
    if daily_meal:
        filters["meal__daily_meal"]=daily_meal
    meals = ShiftMeal.objects.filter(**filters)
    # meals=ShiftMeal.objects.filter(shift__shift_name=shift_name)
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
    shift_meal_id:dict = request.data.get('shift-meal-id')
    work_flow,created=WorkFlow.objects.get_or_create(shift__shift_meals__id=shift_meal_id)
    if not created:
        return Response(data={"error":"you have already reserve this shift meal"},status=status.HTTP_306_RESERVED)
    serialized=WorkFlowSerializer(work_flow,many=False)
    return Response(data=serialized.data,status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def create_shift_meal(request:Request):
    shift_name=request.data.get('shift_name')
    date=request.data.get('date')
    meal_id=request.data.get('meal-id') 
    if not shift_name or not date or not meal_id:
        return Response({"error": "shift or date or meal is required."}, status=status.HTTP_400_BAD_REQUEST)
    try:
        shift,created=Shift.objects.get_or_create(shift_name=shift_name)
        meal=Meal.objects.get(id=meal_id)
        shift_meal,created=ShiftMeal.objects.get_or_create(shift=shift,date=ISO_to_gregorian(date),meal=meal)
        if not created:
            return Response(data={"error":"you have already create this shift meal"},status=status.HTTP_306_RESERVED)
        serialized=ShiftMealSerializer(shift_meal,many=False)
        return Response(data=serialized.data,status=status.HTTP_201_CREATED)
    except Meal.DoesNotExist:
        return Response(data={"error":f"there no existing meal with id {meal_id}"})
    







