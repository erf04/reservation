from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework import status
from rest_framework import permissions
from .serializers import MealSerializer,ShiftMealSerializer,WorkFlowSerializer,ShiftSerializer,FoodSerializer
from rest_framework.decorators import api_view,permission_classes
from .models import ShiftMeal,Meal,WorkFlow,Shift,Food,FoodType,DailyMeal
import jdatetime
from rest_framework.views import APIView


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
    try:
        shift_meal:ShiftMeal=ShiftMeal.objects.get(id=shift_meal_id)
        shift=shift_meal.shift
        work_flow,created=WorkFlow.objects.get_or_create(shift=shift,shift__shift_meals=shift_meal,user=request.user)

    except ShiftMeal.DoesNotExist:
        return Response(data={"error":f"no shift meal with id {shift_meal_id}"},status=status.HTTP_204_NO_CONTENT)
    if not created:
        return Response(data={"error":"you have already reserve this shift meal"},status=status.HTTP_306_RESERVED)
    serialized=WorkFlowSerializer(work_flow,many=False)
    return Response(data=serialized.data,status=status.HTTP_201_CREATED)




class ShiftMealAPIView(APIView):
    permission_classes=[permissions.IsAuthenticated]


    def post(self,request:Request,*args,**kwargs):
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
            return Response(data={"error":f"there no existing meal with id {meal_id}"},status=status.HTTP_204_NO_CONTENT)
        except Shift.DoesNotExist:
            return Response(data={"error":f"there no existing shift with name {shift_name}"},status=status.HTTP_204_NO_CONTENT)
        
    def get(self,request,*args,**kwargs):
        meals=Meal.objects.all()
        meal_serialized=MealSerializer(meals,many=True)
        shifts=Shift.objects.all()
        shift_serialized=ShiftSerializer(shifts,many=True)
        return Response(data={"meals":meal_serialized.data,"shifts":shift_serialized.data},status=status.HTTP_200_OK)
    

class MealAPIView(APIView):
    def post(self,request:Request,*args,**kwargs):
        pass

    def get(self,request:Request,*args,**kwargs):
        foods=Food.objects.all()
        food_types=FoodType.get_values()
        daily_meals=DailyMeal.get_values()
        foods_serialized=FoodSerializer(foods,many=True)
        return Response(data={
            "foods":foods_serialized.data,
            "food_types":food_types,
            "daily_meals":daily_meals  
        },status=status.HTTP_200_OK)
        # print(food_types)


    







