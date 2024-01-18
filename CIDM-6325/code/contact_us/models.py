from django.db import models
from django.core.validators import MaxValueValidator, MinValueValidator, EmailValidator, validate_email


# Create your models here.
class ContactUs(models.Model):
    firstName = models.CharField(
        max_length=40,
        null=False
    )
    lastName = models.CharField(
        max_length=80,
        null=False
    )
    email = models.CharField(
        max_length=80,
        null=False,
        validators=[
            EmailValidator,
            validate_email
        ]
    )
    company = models.CharField(
        max_length=80,
        null=False
    )
    scheduledDate = models.CharField(
        max_length=10,
        null=False
    )
    scheduleTime = models.CharField(
        max_length=5,
        null=False
    )
    description = models.CharField(
        max_length=255
    )
    donationAmount = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=10.00,
        null=True
    )
    minutes = models.IntegerField(
        default=30,
        null=False,
        validators=[
            MinValueValidator(5),
            MaxValueValidator(120)
        ]
    )
    isTestOnly = models.BooleanField(
        default=False,
        null=True,
    )


class EventSchedulerGetResponse(models.Model):
    available = models.BooleanField()
    isSuccess = models.BooleanField()
    message = models.CharField(null=True, max_length=255)


class AvailableDay(models.Model):
    day = models.DateField


class AvailableTime(models.Model):
    startTime = models.CharField(
        max_length=5,
        null=False
    )
    endTime = models.CharField(
        max_length=5,
        null=False
    )

