# CIDM-6325-71-Final
This project will provide the ability to view blog posts and schedule a consolutation with a user listed. 

I am planning on using the domain cidm6325.hardycs.com

I'm planning on using Heroku as my deployment strategy 
## User Features
| Feature | Django Component(s)
| --------- | --------- |
| a) View Blog Entries | Templates, Template Inheritance, Views, Class-Based Views, URLs, Routing, Model Classes, Tests, Static Files, Queries, Postgres, bootstrap, Custom templates, heroku deployment, static assets with ngnix and whitenoise, ssl, task scheduling, CI/CD, Model Enhancements, Views |
| b) Submit Forms (including articles) | Templates, Template Inheritance, Views, Class-Based Views, URLs, Routing, Model Classes, Tests, Static Files, class-based form, authentication, Postgres, custom user models, ad hoc forms, bootstrap, Custom templates, Account management, email, django_crispy_forms, authorization, ManyToMany rels, heroku deployment, ssl, CI/CD, Model Enhancements, Users and SSO, Views |
| c) Register/Auth | Templates, Template Inheritance, Views, Class-Based Views, URLs, Routing, Model Classes, Tests, Static Files, Queries, class-based form, authentication, Postgres, custom user models, ad hoc forms, bootstrap, Custom templates, Account management, email, django_crispy_forms, authorization, heroku deployment,  ssl, CI/CD, APIs, Model Enhancements, Users and SSO, Views |
| d) Submit Request For Appointment | Templates, Template Inheritance, Views, Class-Based Views, URLs, Routing, Model Classes, Tests, Static Files, Queries, class-based form, authentication, Postgres, custom user models, ad hoc forms, bootstrap, Custom templates, django_crispy_forms, authorization, heroku deployment, ssl, middleware, CI/CD, APIs, Model Enhancements, Views |
| e) Site Admnistration | Templates, Template Inheritance, Views, Class-Based Views, URLs, Routing, Model Classes, Django Admin configuration, Tests, Static Files, Queries, class=based form, authentication, Postgres, custom user models, ad hoc forms, bootstrap, Custom templates, Account management, email, authorization, ManyToMany rels, heroku deployment, ssl, CI/CD, Django Admin, APIs, Model Enhancements, Users and SSO, Views |
## Django Features to User Feature
| User Feature  | Topic                                   | Baseline  | Good  | Better  | Best
| ---           | ---                                     | ---       | ---   | ---     | ---
| a, b, c, d, e | Templates                               | X         |       |         |
| a, b, c, d, e | Template Inheritance                    | x         |       |         |
| a, b, c, d, e | Views                                   | X         |       |         |
| a, b, c, d, e | Class-Based Views                       | x         |       |         |
| a, b, c, d, e | URLs                                    | x         |       |         |
| a, b, c, d, e | Routing                                 | x         |       |         |
| a, b, c, d, e | Model Classes                           | x         |       |         |
| e             | Django Admin configuration              | x         |       |         |
| a, b, c, d, e | Tests                                   |           | x     |         |
| a, b, c, d, e | Static Files                            | x         |       |         |
| a, c, d, e    | Queries                                 | x         |       |         |
| b, c, d       | Class-Based Form                        | x         |       |         |
| b, c, d, e    | Authentication                          | x         |       |         |
| a, b, c, d, e | Postgres                                |           | x     |         |
| b, c, d, e    | Custom user models                      |           | x     |         |
| b, c, d, e    | Ad hoc forms                            |           | x     |         |
| a, b, c, d, e | Bootstrap                               | x         |       |         |
| a, b, c, d, e | Custom templates                        |           | x     |         |
| b, c, e       | Account management                      |           | x     |         |
| b, c, e       | Email                                   |           | x     |         |
| b, c, d       | django_crispy_forms                     |           | x     |         |
| b, c, d, e    | authorization                           |           | x     |         |
| b, e          | ManyToMany rels                         |           | x     |         |
| a, b, c, d, e | heroku deployment                       |           |       | x       |
| a             | static assets with ngnix and whitenoise |           | x     |         |
| a, b, c, d, e | SSL                                     | x         |       |         |
| d             | Custom middleware                       |           |       | x       |
| a             | Task scheduling with cron               |           | x     | x       |
| a, b, c, d, e | CI/CD with Github                       |           |       |         | x
|***3rd Party***                         |           |       |         |
| e             | [Django admin](https://github.com/wsvincent/awesome-django#admin) | | | | x
| d             | [APIs](https://github.com/wsvincent/awesome-django#apis) | |  |         | x
| a, b, c, d, e | [Model enhancements](https://github.com/wsvincent/awesome-django#models) |   |   |   | x
| b, c, e       | [Users and SSO](https://github.com/wsvincent/awesome-django#users) |   |   |   | x
| a, b, c, d, e | [Views](https://github.com/wsvincent/awesome-django#views) |   |   |   | x
