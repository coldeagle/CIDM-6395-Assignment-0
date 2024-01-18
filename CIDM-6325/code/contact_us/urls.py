from django.urls import path
from .views import GetContactInfoAndConfirm, GetAvailableDatesAndTimes, SelectDayAndTime, ScheduledView

urlpatterns = [
    path("request_date", GetAvailableDatesAndTimes.as_view(), name="request_date"),
    path("request_time", SelectDayAndTime.as_view(), name="request_time"),
    path("book_date", GetContactInfoAndConfirm.as_view(), name="book_date"),
    path("scheduled", ScheduledView.as_view(), name="scheduled"),
]
