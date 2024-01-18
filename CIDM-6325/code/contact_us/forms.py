from django import forms
from django.forms import ModelForm, Textarea, DateField, HiddenInput
from datetime import date
from .models import ContactUs
from django.contrib.auth import get_user_model

User = get_user_model()


class GetContactDate(forms.Form):
    preferred_day = forms.DateField(
        label='What is the date you would like to meet?',
        initial=date.today().isoformat(),
        widget=forms.TextInput(
            attrs={'type': 'date'}
        )
    )


class GetContactInfo(ModelForm):
    success_url = 'request_time'

    class Meta:
        model = ContactUs
        fields = ['firstName', 'lastName', 'email', 'company', 'scheduledDate', 'scheduleTime', 'minutes', 'description', 'donationAmount', 'isTestOnly']
        widgets = {
            'description': Textarea(attrs={'cols': 80, 'rows': 6}),
            'scheduleDate': DateField,
            'isTestOnly': forms.HiddenInput()
        }


