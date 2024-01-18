from django.contrib.auth.forms import UserCreationForm, UserChangeForm

from .models import CustomUser

from django.contrib.auth import get_user_model

User = get_user_model()


class CustomUserCreationForm(UserCreationForm):
    class Meta(UserCreationForm):
        model = CustomUser
        fields = (
            "first_name",
            "last_name",
            "username",
            "email",
            #"age",
            #"sfdc_username",
            "company_name",
            "phone_number",
        )


class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = CustomUser
        fields = (
            "first_name",
            "last_name",
            "username",
            "email",
            #"age",
            #"sfdc_username",
            "company_name",
            "phone_number",
        )
