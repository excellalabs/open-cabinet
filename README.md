[![Build Status](https://magnum.travis-ci.com/excellaco/open-cabinet.svg?token=ztW2D3QGwNvKdJWTdpNu)](https://magnum.travis-ci.com/excellaco/open-cabinet)
[![Code Climate](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/gpa.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/feed)
[![Test Coverage](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/coverage.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/coverage) 

##### Getting Started
[Download VirtualBox](https://www.virtualbox.org/wiki/Downloads)
[Download Vagrant](http://www.vagrantup.com/downloads)
After installing, navigate to the repo directory and create a Vagrantfile using the Vagrantfile.example as an example.
After you create the Vagrantfile run:
```vagrant up```

##### To keep guard running in the background with Rubocop and Rspec simply run:
```ruby
bundle exec guard
```

##### Logging
[view logs](https://logentries.com/app/cacec443#id=9c562ff3-3cee-4162-a461-2fb7b3270b74&r=d&s=log_sets)

To use logging with LE 
```ruby
Rails.logger.warn("Look at me, I'm a warning")
```

