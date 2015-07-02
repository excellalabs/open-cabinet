### Local Environment Setup

## Prerequisites
OpenCabinet was developed on Ubuntu 14.04 using Virtualbox, an operating system virtualization tool which allows you to install a guest operating system on your workstation, and Vagrant, a wrapper for Virtualbox.

To create Ubuntu on your workstation:
- Install [Oracle Virtualbox](https://www.virtualbox.org/wiki/Downloads) 
- Install [Vagrant](https://www.vagrantup.com/downloads.html) 


## Operating System Setup
Clone the [OpenCabinet](https://github.com/excellaco/open-cabinet) repo to your workspace. Vagrant configuration directives are contained in a Vagrantfile. 

In the root of the OpenCabinet project there is a Vagrantfile.example. This file may be used as a template for generating your own configuration. 

To have Vagrant configure your development environment: 
- Copy the Vagrantfile.example to Vagrantfile
- Run ```vagrant up``` 
 - Vagrant will download and install Ubuntu 14.04, Ruby, and supporting software. 
- Run ```vagrant ssh``` to login to your environment.

## Project Setup
To set-up our project:
- Navigate to the root of the OpenCabinet project on your guest machine (the host OS to guest OS path mapping is given by the ```config.vm.synced_folder``` directive in your Vagrantfile). 
- In the root of the OpenCabinet project, navigate to config/ to find the secrets.yml.sample 
 - This file holds sensitive project configuration data. 
- Copy secrets.yml.sample to secrets.yml and configure the following values for your development and test environments:
 - ```DATABASE_IP``` This should match your guest OS IP which is given by the Vagrant ```config.vm.network ``` directive
 - ```DATABASE_USERNAME```
 - ```DATABASE_PASSWORD``` The database login data. These values are set in the ```users``` attribute of the ```chef.json``` section
 - ```BASIC_AUTH_USERNAME```
 - ```BASIC_AUTH_PASSWORD``` The browser login for your OpenCabinet app.
 - ```open_fda_import_key``` Your [OpenFDA](https://open.fda.gov/api/reference/#your-api-key) development key
- In the root of the OpenCabinet project, navigate to config/environments/. 
 - Create a development.rb from the development.rb.sample.


Navigate to the root of your app and run ```bundle install```. 

Finally run ```rake db:create db:migrate``` to configure your database.

## Project Commands
To run test:
- Unit tests: run ```rspec```
- Acceptance tests: run ```rake cucumber```

To import autocomplete data:
- Run ```rake searchable_medicines:import``` (logs are available at log/development.log). 

To start your local server:
- Run ```rails s -b 0.0.0.0```  

The app will be available at: 
[http://192.168.33.10:3000/](http://192.168.33.10:3000/)
