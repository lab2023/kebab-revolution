# Welcome to Kebab

Kebab Revolution is a saas system which support

* Multitenant
* Paypal Recurring Payments
* Authentication
* Authorization with Role Base
* Subscription

We use ExtJs 4.0 for client and Ror 3.1.3 for server.

# Kebab Revolution Resource

* [Web Site](http://www.kebab-project.com)
* [Forumm](http://kebab-project.2299591.n4.nabble.com/Kebab-Project-2-0-x-Revolution-f3832977.html)
* [Online IRC - Chat](http://webchat.freenode.net/?channels=kebabproject)

# Changelog

## 2.0.0.alpha6 -

* 77 - Subscription limit controller
* 49 - User invite
* 76 - Change user status
* 72 - User cancel own account
* 81 - Change server local
* 80 - Cancel account
* 79 - See older and next payments info
* 73 - Add SubscriptionNotifier
* 55 - Paypal integration
* 60 - Added options for trial period for paypal
* 69 - Invoice no problem
* 78 - Update plan

## 2.0.0.alpha5 - 2012.01.11

* DONE - Tenant register
* DONE - Plan Model
* DONE - Subscription Model
* DONE - Payments Model
* DONE - Add time zone
* DONE - User profile
* DONE - Feedback
* DONE - Update static pages

## 2.0.0.alpha4 - 2012.01.01

* DONE - Create authentication system
* DONE - Create authorization system
* DONE - Improve xhr? request for 401, 403, 404 status
* DONE - Add all ruby doc
* DONE - User forget password
* DONE - Create desktop and login pages

## 2.0.0.alpha3 - 2011.12.21

* DONE - Create role model
* DONE - Create privilege model
* DONE - Create application model
* DONE - Create service model
* DONE - Return apps, stories, etc for desktop env after login.
* DONE - Add locale to user model
* DONE - Remove is_owner from User Table and user_id to Tenant Table

*Bugs*

* FIXED - remove set_i18n_locale_from_accept_language_header from application_controller.rb
* FIXED - fixed sessions_controller_spec.rb test
* FIXED - remove coninja string from omitted subdomain

## 2.0.0.alpha2 - 2011.12.14

* DONE - Setup rails env
* DONE - Create README.md
* DONE - Set up test env
* DONE - Create a response hash for ext js
* DONE - Support multi-tenant
* DONE - Create session/register action for client register
* DONE - Create user resource
* DONE - Support i18n for English, Turkish and Russian
* DONE - Change root of site to session/register 
