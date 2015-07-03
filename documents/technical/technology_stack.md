# Table of Contents
- [Environment](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#environment)
- [Continuous Integration and Deployment](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#user-content-continuous-integrationcontinuous-deployment)
- [Front-End](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#front-end)
- [Back-End](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md#back-end)


***


## Environment

### PaaS
- Heroku – cloud based application platform

### Software Container
- Vagrant/Virtualbox – OS level virtualization
- Chef – Infrastructure setup as code
- Docker - Software container

## Continuous Integration/Continuous Deployment
### Test Framework
- Rspec – Used for unit testing of Ruby Code
- Capybara/Cucumber/Poltergeist – Used for acceptance testing
- Teaspoon with Mocha – Javascript testing framework
- Guard – Automates running of Rubocop and Rspec in the background  for local enviroments
- Rubocop – Ruby static code analysis

### Pipeline
- Travis – Continuous integration server
- Code-Climate – Static Code analysis including test coverage and potential security issues
- Brakeman – Rails specific security warnings

### Continuous Monitoring
- New Relic – Application monitoring in the production environment
- Log Entries – Cloud hosted logging service
- Air Brake – Exception handling and stack trace container for production
- Heroku Logs – Raw production logs for Heroku server

## Front-End
- T3 – Minimalist javascript framework
- Sass – CSS extension language
- Bourbon and Neat – Lightweight mixin library for sass and semantic grid framework
- Flip - A/B testing tool
- Twitter Typeahead – javascript library for building typeaheads
- Auto Prefixer - add vendor prefixes to CSS rules using values from Can I Use

## Back-End
- Dalli Store – Memcache server accessor for rails
- Memcachier – Memcache server manager and scaler
- Postgres - Database

