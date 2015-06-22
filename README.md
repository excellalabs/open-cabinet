[![Build Status](https://magnum.travis-ci.com/excellaco/open-cabinet.svg?token=ztW2D3QGwNvKdJWTdpNu)](https://magnum.travis-ci.com/excellaco/open-cabinet)
[![Code Climate](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/gpa.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/feed)
[![Test Coverage](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/coverage.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/coverage) 

https://opencabi.net

##### Getting Started
[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)

[Download Vagrant](http://www.vagrantup.com/downloads)

After installing, navigate to the repo directory and create a Vagrantfile using the Vagrantfile.example as an example.
After you create the Vagrantfile run:
```vagrant up```

To download a fresh set of searchable medicines (takes a while), run:
```rake searchable_medicines:download['path to file']```
Then run:
```rake searchable_medicines:import```

##### To keep guard running in the background with Rubocop and Rspec simply run:
```ruby
bundle exec guard
```

##### Approach
* 750 words max on approach used to create the prototype
* FDA dataset endpoints used
* Team:
  * Accountable leader assigned
  * Multidisciplinary and collaborative team
  * Pool one (design) min 3 of: Product Manager, Interaction Designer/User Researcher/Usability Tester, Writer/Content Designer/Content Strategist, Visual Designer, Front End Web Designer
  * Pool two (dev) min 2 of: Technical Architect, Front End Web Developer, Backend Web Developer, DevOps Engineer
  * Pool three (full) min 5 of: above plus Security Engineer, Delivery Manager, Agile Coach, Business Analyst, Digital Performance Analyst
* Understanding of people need in the design process
* Min 3 human centered design techniques
* Design style guide and/or pattern library
* Min 5 open source web techs: Ruby on Rails, rspec
* Usability tests
* Interactive, user feedback informed subsequent prototype versions
* Responsive design
* Deployed to PaaS - Heroku
* Unit tests written with rspec
* Continuous Integration with Travis CI, continuous deployment to Heroku
* Continuous monitoring with New Relic
* Local development with Vagrant

