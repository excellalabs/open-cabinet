# Table of Contents
- [Environment](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#environment)
- [Continuous Integration and Deployment](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#user-content-continuous-integrationcontinuous-deployment)
- [Framework](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#user-content-framework)
 - [Front-End](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#front-end)
 - [Back-End](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#back-end)


***


## Environment

### PaaS

technology | description
---------- | -----------
Heroku     | cloud based application platform

### Software Container
technology         | description
----------         | -----------
Vagrant/Virtualbox | OS level virtualization
Chef               | Infrastructure setup as code
Docker             | Platform for distributed applications for developers and sysadmins

## Continuous Integration/Continuous Deployment
### Test Framework

technology                    | description
----------                    | -----------
Rspec                         | Used for unit testing of Ruby Code
Capybara/Cucumber/Poltergeist | Used for acceptance testing
Teaspoon with Mocha           | Javascript testing framework
Guard                         | Automates running of Rubocop and Rspec in the background  for local enviroments
Rubocop                       |  Ruby static code analysis

### Pipeline
technology       | description
----------       | -----------
Travis           | Continuous integration server
Code-Climate     | Static Code analysis including test coverage and potential security issues
Brakeman         | Rails specific security warnings
SauceLabs        | Cross browser testing

### Continuous Monitoring
technology       | description
----------       | -----------
New Relic        | Application monitoring in the production environment
Log Entries      | Cloud hosted logging service
Air Brake        | Exception handling and stack trace container for production
Heroku Logs      | Raw production logs for Heroku server
Google Analytics | Web site user statistics


## Framework
technology        | description
----------        | -----------
Ruby on Rails     | Web application framework 

### Front-End
technology        | description
----------        | -----------
JQuery            | Fast, small, and feature-rich JavaScript library
T3                | Minimalist javascript framework
Sass              | CSS extension language
Bourbon and Neat  | Lightweight mixin library for sass and semantic grid framework
Flip              | A/B testing tool
Twitter Typeahead | javascript library for building typeaheads
Auto Prefixer     | Add vendor prefixes to CSS rules using values from Can I Use

### Back-End
technology        | description
----------        | -----------
Dalli Store       | Memcache server accessor for rails
Memcachier        | Memcache server manager and scaler
Postgres          | Database
Puma              | Ruby web server

