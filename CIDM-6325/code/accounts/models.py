from django.db import models
from django.contrib.auth.models import AbstractUser


class CustomUser(AbstractUser):
    age = models.PositiveIntegerField(
        null=True,
        blank=True
    )
    sfdc_username = models.CharField(
        max_length=80,
        unique=True,
        null=True,
        blank=True
    )
    company_name = models.CharField(
        max_length=80,
        null=True,
        blank=True
    )
    phone_number = models.CharField(
        max_length=80,
        null=True,
        blank=True
    )


