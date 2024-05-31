from django.contrib import admin
from .models import *
import django_jalali.admin as jadmin
from django import forms
from django_jalali.forms import jDateField
# Register your models here.


class ShiftMealForm(forms.ModelForm):
    date = jDateField(widget=jadmin.widgets.AdminjDateWidget)
    class Meta:
        model=ShiftMeal
        fields="__all__"

class SupervisorRecordForm(forms.ModelForm):
    from_date = jDateField(widget=jadmin.widgets.AdminjDateWidget)
    to_date = jDateField(widget=jadmin.widgets.AdminjDateWidget)
    class Meta:
        model=SupervisorRecord
        fields="__all__"

class ShiftMealAdmin(admin.ModelAdmin):
    form = ShiftMealForm
    list_display = ('meal', 'date')
    search_fields = ('meal', 'date')



class SupervisorRecordAdmin(admin.ModelAdmin):
    form = ShiftMealForm
    list_display = ('user','supervisor','from_date','to_date')
    search_fields = ('user','supervisor','from_date','to_date')

admin.site.register(ShiftMeal,ShiftMealAdmin)
admin.site.register(SupervisorRecord,SupervisorRecordAdmin)
admin.site.register(Meal)
admin.site.register(User)
# admin.site.register(ShiftType)
admin.site.register(Shift)
admin.site.register(ShiftManager)
admin.site.register(DailyMeal)
admin.site.register(WorkFlow)
admin.site.register(Food)
admin.site.register(FoodType)
# admin.site.register(F)