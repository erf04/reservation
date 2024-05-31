from django.db import models
from django.contrib.auth.models import AbstractUser
import django_jalali.db.models as jmodels
# Create your models here.

class User(AbstractUser):
    profile=models.ImageField(upload_to='profiles/',blank=True,null=True,default='defaults/user.png',verbose_name='پروفایل')

    class Meta:
        verbose_name = 'کاربر'
        verbose_name_plural = 'کاربران'

class ShiftType(models.TextChoices):
    A='A','A'
    B='B','B'
    C='C','C'
    D='D','D'


class Shift(models.Model):
    shift_name = models.CharField(max_length=100, choices=ShiftType.choices,verbose_name='نوع شیفت')

    class Meta:
        verbose_name='شیفت'
        verbose_name_plural='شیفت ها'

class WorkFlow(models.Model):
    user=models.ForeignKey(User,on_delete=models.CASCADE,related_name='work_flows')
    shift=models.ForeignKey(Shift,on_delete=models.CASCADE,related_name='work_flows')

    class Meta:
        verbose_name='ساعت کاری'
        verbose_name_plural='ساعت کاری ها'


class ShiftManager(models.Model):
    user=models.OneToOneField(User,on_delete=models.CASCADE,verbose_name='کاربر')
    shift=models.OneToOneField(Shift,on_delete=models.CASCADE,verbose_name="شیفت")

    class Meta:
        verbose_name='مدیر شیفت'
        verbose_name_plural='مدیران شیفت'


class SupervisorRecord(models.Model):
    user=models.ForeignKey(User,on_delete=models.CASCADE,verbose_name="کاربر")
    supervisor=models.ForeignKey(ShiftManager,on_delete=models.CASCADE,verbose_name="منصوب کننده")
    from_date=jmodels.jDateField(verbose_name='از تاریخ')
    to_date=jmodels.jDateField(verbose_name='تا تاریخ')

    class Meta:
        verbose_name="مسیولیت"
        verbose_name_plural='مسیولیت ها'


class Food(models.TextChoices):
    pass

class FoodType(models.TextChoices):
    pass

class DailyMeal(models.TextChoices):
    pass

class Meal(models.Model):
    food=models.CharField(max_length=50,choices=Food.choices,verbose_name="نام غذا")
    food_type=models.CharField(max_length=50,choices=FoodType.choices,verbose_name="نوع غذا")
    daily_meal=models.CharField(max_length=50,choices=DailyMeal.choices,verbose_name="وعده غذا")

    class Meta:
        verbose_name="وعده"
        verbose_name_plural="وعده ها"



class ShiftMeal(models.Model):
    meal=models.ForeignKey(Meal,on_delete=models.CASCADE,verbose_name="وعده")
    date=jmodels.jDateField(verbose_name='تاریخ')
    shift=models.ForeignKey(Shift,on_delete=models.CASCADE,verbose_name="شیفت")

    class Meta:
        verbose_name="وعده شیفت"
        verbose_name_plural="وعده های شیفت"
    





