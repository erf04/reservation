from django.contrib import admin
from .models import *
import django_jalali.admin as jadmin
from django import forms
from django_jalali.forms import jDateField
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
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

class ReservationForm(forms.ModelForm):
    date=jDateField(widget=jadmin.widgets.AdminjDateWidget)
    class Meta:
        model=Reservation
        fields="__all__"

class ShiftMealAdmin(admin.ModelAdmin):
    form = ShiftMealForm
    list_display = ('meal', 'date')
    search_fields = ('meal', 'date')



class SupervisorRecordAdmin(admin.ModelAdmin):
    form = ShiftMealForm
    list_display = ('user','shift_manager','from_date','to_date')
    search_fields = ('user','shift_manager','from_date','to_date')

class ReservationAdmin(admin.ModelAdmin):
    form = ReservationForm
    list_display = ('user','date','shift_meal')
    search_fields = ('user','date','shift_meal')

class CustomUserAdminForm(forms.ModelForm):
    class Meta:
        model = User
        fields = '__all__'

    is_supervisor = forms.BooleanField(label='Supervisor', required=False, widget=forms.CheckboxInput(attrs={'class': 'custom-checkbox'}))
    is_shift_manager = forms.BooleanField(label='Shift Manager', required=False, widget=forms.CheckboxInput(attrs={'class': 'custom-checkbox'}))

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Initialize the initial values for is_supervisor and is_shift_manager
        if self.instance.pk:
            self.initial['is_supervisor'] = self.instance.is_supervisor
            self.initial['is_shift_manager'] = self.instance.is_shift_manager

    def save(self, commit=True):
        user = super().save(commit=False)
        user.is_supervisor = self.cleaned_data['is_supervisor']
        user.is_shift_manager = self.cleaned_data['is_shift_manager']
        print(user.is_supervisor,user.is_shift_manager)
        print('in save')
        if commit:
            user.save()
            print('in if')
        return user

class UserAdmin(BaseUserAdmin):
    form = CustomUserAdminForm
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        (('Personal info'), {'fields': ('first_name', 'last_name', 'email')}),
        (('Permissions'), {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions', 'is_supervisor', 'is_shift_manager')}),
        (('Important dates'), {'fields': ('last_login', 'date_joined')}),
    )

    list_display = ('username', 'email', 'first_name', 'last_name', 'is_staff', 'is_superuser', 'is_active', 'is_supervisor', 'is_shift_manager')
    list_filter = ('is_staff', 'is_superuser', 'is_active')



# Unregister the original User admin and register the new one
# admin.site.unregister(User)
admin.site.register(User, UserAdmin)

admin.site.register(ShiftMeal,ShiftMealAdmin)
admin.site.register(SupervisorRecord,SupervisorRecordAdmin)
admin.site.register(Meal)
# admin.site.register(User)
admin.site.register(Food)
admin.site.register(Shift)
admin.site.register(ShiftManager)
admin.site.register(Drink)
# admin.site.register(Reservation)
admin.site.register(Reservation,ReservationAdmin)

