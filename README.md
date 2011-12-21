# Welcome to Kebab 

# Kebab Revolution Resource

* [Web Site](http://www.kebab-project.com)
* [Forumm](http://kebab-project.2299591.n4.nabble.com/Kebab-Project-2-0-x-Revolution-f3832977.html)
* [Online IRC - Chat](http://webchat.freenode.net/?channels=kebabproject)

# Changelog

## 2.0.0.alpha4 -

* Integrate Devise
* Integrate Kebab ACL System
* Add GET users/id method
* Add PUT users/id method
* Add user#forget_password method

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
