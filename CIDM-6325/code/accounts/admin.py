from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .forms import CustomUserCreationForm, CustomUserChangeForm
from .models import CustomUser


class CustomUserAdmin(UserAdmin):
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm
    model = CustomUser
    list_display = [
        "email",
        "username",
        "age",
        "is_staff",
        "sfdc_username",
        "company_name",
        "phone_number",
    ]
    fieldsets = UserAdmin.fieldsets + ((None, {"fields": ("age", "sfdc_username", "company_name", "phone_number",)}),)
    add_fieldsets = UserAdmin.add_fieldsets + ((None, {"fields": ("age", "sfdc_username", "company_name", "phone_number",)}),)
    change_form_template = 'loginas/change_form.html'


admin.site.register(CustomUser, CustomUserAdmin)
