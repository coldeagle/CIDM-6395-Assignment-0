from decimal import *
from django.views.generic.base import TemplateView
import json
from django.views.generic import FormView
from django.db import connections
from .forms import GetContactDate, GetContactInfo
from django.core.mail import send_mail


class GetAvailableDatesAndTimes(FormView):
    form_class = GetContactDate
    template_name = 'contact_us/date_request.html'
    success_url = 'request_time'

    def post(self, request, *args, **kwargs):
        form = self.get_form()

        if form.is_valid():

            preferred_day = request.POST.get('preferred_day')

            self.success_url+='?RequestDate='+preferred_day

            return self.form_valid(form)
        else:
            return self.form_invalid(form)


class SelectDayAndTime(TemplateView):
    template_name = 'contact_us/date_time_select.html'

    def get_context_data(self, *args, **kwargs):
        context = super().get_context_data(**kwargs)
        preferred_day = self.request.GET.get('RequestDate')
        cursor = connections['salesforce'].cursor()
        relative_url = '/services/apexrest/getEvents/v1/?RequestDate='+preferred_day
        res = cursor.cursor.handle_api_exceptions('GET', relative_url)
        context['response_json'] = json.loads(res.json())

        return context


class GetContactInfoAndConfirm(FormView):
    form_class = GetContactInfo
    template_name = 'contact_us/confirmation.html'
    success_url = 'scheduled'

    def get_initial(self):
        initial = super().get_initial()
        user = self.request.user
        email=''
        first_name=''
        last_name=''
        company_name=''
        phone_number=''

        if user.is_authenticated:
            first_name = user.first_name
            last_name = user.last_name
            email = user.email
            company_name = user.company_name
            phone_number = user.phone_number

        initial['scheduledDate'] = self.request.GET.get('scheduledDate')
        initial['scheduleTime'] = self.request.GET.get('startTime')
        initial['firstName'] = first_name
        initial['lastName'] = last_name
        initial['email'] = email
        initial['company'] = company_name

        isTestOnly = self.request.GET.get('IsTestOnly')
        if not isTestOnly == None:
            initial['isTestOnly'] = isTestOnly

        return initial

    def post(self, request, *args, **kwargs):
        form = self.get_form()
        if form.is_valid():

            cursor = connections['salesforce'].cursor()
            relative_url = '/services/apexrest/postEvents/v1/'
            json_str = json.dumps(form.cleaned_data, cls=DecimalEncoder)
            res = cursor.cursor.handle_api_exceptions('POST', relative_url, json=json_str)

            jsonRes = json.loads(res.json())

            if not jsonRes['isSuccess']:
                form.add_error(None, 'There was a problem: '+jsonRes['message'])
                return self.form_invalid(form)
            if jsonRes['isSuccess']:
                str_msg = 'Thank you for scheduling an appointment on '+form.cleaned_data['scheduledDate']+' at '+form.cleaned_data['scheduleTime']+' for '+str(form.cleaned_data['minutes'])+' minutes.'
                send_mail(
                    subject='Your appointment has been scheduled!',
                    message=str_msg,
                    html_message='<p>'+str_msg+'</p>',
                    from_email='no-reply@hardycs.com',
                    fail_silently=True,
                    recipient_list=[form.cleaned_data['email']]
                )
            return self.form_valid(form)
        else:
            return self.form_invalid(form)


class ScheduledView(TemplateView):
    template_name = 'contact_us/event_scheduled.html'


class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        # 👇️ if passed in object is instance of Decimal
        # convert it to a string
        if isinstance(obj, Decimal):
            return str(obj)
        # 👇️ otherwise use the default behavior
        return json.JSONEncoder.default(self, obj)