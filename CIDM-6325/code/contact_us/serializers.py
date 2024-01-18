from rest_framework import serializers
from .models import AvailableDay, AvailableTime, ContactUs, EventSchedulerGetResponse

class EventSchedulerGetAvailability(serializers.Serializer):
    day = serializers.DateField()


class ContactUs(serializers.ModelSerializer):
    class Meta:
        model = ContactUs
        fields = '__all__'


class EventSchedulerGetResponse(serializers.ModelSerializer):
    availableDays = AvailableDay(many=True)

    class Meta:
        model = EventSchedulerGetResponse
        fields = '__all__'


class AvailableDayHere(serializers.ModelSerializer):
    availableTimes = AvailableTime(many=True)

    class Meta:
        model = AvailableDay
        fields = '__all__'
