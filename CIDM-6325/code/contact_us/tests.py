from django.contrib.auth import get_user_model
from django.test import TestCase

Pref_day = '2022-01-01'


# Create your tests here.
class ContactRequest(TestCase):
    databases = '__all__'

    @classmethod
    def setUpTestData(cls):
        cls.user = get_user_model().objects.create_user(
            first_name='fn',
            last_name='ln',
            company_name='companytest',
            username="testuser",
            email="test@email.com",
            password="secret",
        )

    def testGetAvailableDatesAndTimes(self):
        data = {}
        data['preferred_day'] = Pref_day

        response = self.client.post('/contact_us/request_date', data)
        self.assertEqual(response.url, 'request_time?RequestDate='+Pref_day)

    def testSelectDayAndTime(self):
        data = {}
        data['RequestDate'] = Pref_day

        response = self.client.get("/contact_us/request_time", data=data)
        self.assertEqual(response.status_code, 200)

    def testBookDate(self):
        login = self.client.login(username='testuser', password='secret')
        self.assertTrue(login)
        data = {}
        data['scheduledDate'] = Pref_day
        data['IsTestOnly'] = True
        data['startTime'] = '09:00'

        response = self.client.get("/contact_us/book_date", data=data)
        self.assertEqual(response.context['form'].initial['company'], 'companytest')

        data = response.context['form'].initial
        data['description'] = 'Testing'
        data['donationAmount'] = 10.0
        data['minutes'] = 30

        response = self.client.post("/contact_us/book_date", data=data)

        self.assertEqual(response.url, '/')
