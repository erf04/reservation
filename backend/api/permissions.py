# permissions.py
from rest_framework.permissions import BasePermission
from rest_framework.request import Request
from .models import User


class IsUserOrReadOnly(BasePermission):
    """
    Custom permission to only allow users to edit their own user instance.
    """

    def has_object_permission(self, request:Request, view, obj):
        # Instance must be the same as the logged-in user
        return obj == request.user
    

class IsSupervisorOrReadOnly(BasePermission):
    def has_permission(self, request:Request, view):
        return request.user.is_supervisor
    

    # def has_object_permission(self, request:Request, view, obj):
    #     # Instance must be the same as the logged-in user
    #     return obj.is_supervisor
