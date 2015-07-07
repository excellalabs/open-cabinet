https://opencabi.net

[![Build Status](https://travis-ci.org/excellaco/open-cabinet.svg?branch=master)](https://travis-ci.org/excellaco/open-cabinet)
[![Code Climate](https://codeclimate.com/github/excellaco/open-cabinet/badges/gpa.svg)](https://codeclimate.com/github/excellaco/open-cabinet)
[![Test Coverage](https://codeclimate.com/github/excellaco/open-cabinet/badges/coverage.svg)](https://codeclimate.com/github/excellaco/open-cabinet/coverage)

---
**`it began with crowdsourcing ...`**

![open-cabinet logo](https://github.com/excellaco/open-cabinet/blob/master/app/assets/images/open-cabinet.png)

##Concept
OpenCabinet is a tool for the public to find interactions between the medicine that they and their family are taking using data directly from the FDA.

##Approach 
**Excella Consulting** followed an agile development framework to build **OpenCabinet** in an iterative, incremental manner.  The cross-functional team, comprised of analysts, designers, and developers, began with Sprint 0, followed by two-day sprints. The team met for a daily stand-up and each sprint ended with a quick review and retrospective.  

The team consisted of the following: 

* Product Manager
* Technical Architect
* User Researcher/Usability Tester
* Writer/Content Designer
* Visual Designer
* Front-End Web Developers
* Back-End Web Developers
* DevOps Engineer
* Business Analyst


The self-organized team not only fulfilled their individual roles in the design and development process, but also helped where needed to deliver a quality product. The Product Manager led the effort by focusing on the value delivered by the final product, which enabled the team to respond quickly to changing priorities and address feedback from **[usability testing](https://github.com/excellaco/open-cabinet/tree/master/documents/design/usability_testing)**. Utilizing **[GitHub issues](https://github.com/excellaco/open-cabinet/issues)**, the team created and groomed a [backlog](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=label%3A%22user+story%22+), discussed [design decisions](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=+label%3Adesign+), and tracked [bugs](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=+label%3Abug+).

---
##Sprint 0
The team used an internal Slack channel to **[crowdsource](https://github.com/excellaco/open-cabinet/blob/master/documents/images/crowdsourcing.png)** ideas for the application using [OpenFDA's Label API](https://open.fda.gov/drug/label/), then met to review the suggestions, and discuss the feasibility of delivering a product in the given timeframe from both design and development perspectives. With an initial idea of "[my medicine cabinet](https://github.com/excellaco/open-cabinet/blob/master/documents/design/brainstorming.md)" agreed upon, the team was ready to begin.  

During Sprint 0, the team achieved four goals:
 
* Explored users’ **needs and reactions**
* Determined the **application's value**
* Decided what **technologies** to use
* Set up the **development environment**

###Needs and Reactions
The User Researcher interviewed potential users to understand their desired needs. This research unveiled that users’ primary goal was to see medical interactions, which caused the Product Manager to modify the initial concept to focus on this feature. The Content Designer created **[Personas](https://github.com/excellaco/open-cabinet/blob/master/documents/design/personas.md)** to represent different user types, and included one in the **[Short-Form Creative Brief](https://github.com/excellaco/open-cabinet/blob/master/documents/design/short_form_creative_brief.md)**, which was read aloud each morning in stand-up. These tools informed the design and features included in the **[Minimal Viable Product](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=label%3Amvp)** (MVP).

###Application's Value
The Business Analyst performed a **[Competitive Analysis](https://github.com/excellaco/open-cabinet/blob/master/documents/design/competitive_analysis.md)**, which revealed that many applications show medical interactions, but the team decided to design and build an application that was simple, easy to use, and incorporated a pleasant user experience. A roadmap for future enhancements, indicated in the **[Product Tree](https://github.com/excellaco/open-cabinet/blob/master/documents/design/product_tree.md)** will further distinguish OpenCabinet from the current marketplace.


###Technologies
The Technical Architect, Front-End, and Back-End Developers collaborated, researched, and evaluated tools to determine the best technologies to develop the prototype. With a focus on open source, rapid prototyping, and code quality, the team decided to use **Ruby on Rails** as the application framework. 

###Development Environment

With the core technology agreed upon, the DevOps Engineer set up a development environment leveraging **Docker**, **Vagrant** and **Chef**. By virtualizing the operating system and providing a **[living set of installation instructions](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/installation.md)**, team members quickly got their environments up in a consistent manner with a prescribed set of required infrastructure. Combined with **GitHub’s version control**, the team set the base for intuitive versioning and consistent baselines for development. The team built a continuous integration and delivery pipeline to deploy a skeleton Rails application, which was deployed onto the PaaS provider, **Heroku**, to allow for scalability. Through the use of **Travis**, the chosen continuous integration server, code was [continuously deployed](https://travis-ci.org/excellaco/open-cabinet) after passing a series of quality assurance checks.


Against every pull request and push to the master branch, Travis automatically ran:

* **RSpec** for unit and integration tests
* **Cucumber/Capybara** for automated acceptance tests
* **Teaspoon/Mocha** for testing JavaScript
* **Rubocop** for static code analysis
* **Brakeman/Code Climate** for security static analysis
* **Code Climate** for code quality metrics
* **SauceLabs** for multiple browser testing

**Travis** was also tightly integrated with GitHub. When performing code reviews on a pull request, the reviewer could see the status of those [tests](https://github.com/excellaco/open-cabinet/blob/master/documents/images/automated-testing.png) to ensure that along with a visual inspection of the code, all tests also passed. These tests and code reviews were incorporated into the team's **[Definition of Done](https://github.com/excellaco/open-cabinet/blob/master/documents/images/definition-of-done.jpg)** to demonstrate that functional code was being deployed to production and that it provided added verifiable value to the product.  

 ![build-pipeline-1](https://github.com/excellaco/open-cabinet/blob/master/documents/images/build_pipeline_v3.png)

The final integration points were to secure the application and bring visibility to the health of the application. **TLS certificates** were acquired and set up to ensure user security. **[Slack](https://github.com/excellaco/open-cabinet/blob/master/documents/images/slack-integrations.png)**, which served as the team’s collaboration forum, was configured to automatically notify the team of changes to the repository, and denoted key checkpoints in the continuous integration process.  The GitHub repository housed **Badges**, which  provided visibility to the code’s [test coverage](https://codeclimate.com/github/excellaco/open-cabinet/coverage), [quality](https://codeclimate.com/github/excellaco/open-cabinet/code), and [build status](https://travis-ci.org/excellaco/open-cabinet/builds), while monitoring tools, **New Relic**, **Log Entries**, **Google Analytics**, and **Air Brake**, captured and alerted key metrics and issues with the system.

The Front-End Web Developer established a lightweight framework that supported OpenCabinet's design patterns and **[Style Guide](https://github.com/excellaco/open-cabinet/blob/master/documents/design/style_guide.md)**, and implemented tools that created structure, but were flexible to meet mobile-responsive design needs.

* For presentation, **Sass**, **Bourbon**, and **Neat** were used to lay the foundation
* For interaction, **T3** was used as the JavaScript framework, and **Teaspoon/Mocha** for testing JavaScript code
* For post processing, **[SauceLabs](https://github.com/excellaco/open-cabinet/blob/master/documents/images/sauce-labs.png)** ran acceptance tests against various browsers and **AutoPrefixer** ensured that vendor prefixes were added to CSS to do the same
* For usability testing, **Flip** implemented feature toggling to support A/B testing

---
##Sprint 1 + 2

###Design
Sprint 1 resulted in two artifacts: 

* The Visual Designer created a **Style Guide** containing guidance on how to use typography, color, and address visual elements to ensure visual consistency.    
* Initial **[prototype mock-ups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_1.md)** for two different layouts, which were used for usability testing. Unanimously, [users](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_1_testing.md) preferred the “cabinet” option, which is represented in the final prototype along with a mobile version.

During Sprint 2, user feedback was incorporated into a [second version of mock-ups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_2.md), which were tested with users to learn that key elements (e.g. navigation and search) were [not well received](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_2_testing.md). The team created issues in GitHub addressing these pain points, which allowed developers to make iterative changes to the application, which were then retested in subsequent rounds of usability testing.


###Development
During Sprints 1 and 2, the development team developed the foundation of the application. Following a strategy of short-lived branches, and continuous integration of small features into the master branch, the team began initial implementation of the API integrations. Caching was implemeted in order to keep API requests performant and limit requests. This set the framework to get features out quickly for usability testing when the designs were complete, which ultimately allowed for constant feedback and improvements of the product.


---

##Sprint 3 + 4  

###Design
The team completed the MVP in Sprints 3 and 4, and began performing usability testing on a functioning application.  With the new interactions in place, the team discovered that users were confused by how medicine selection worked. The interaction visualizations were then re-evaluated and the team created alternative options to test with users through [feature toggle](https://opencabi.net/features).

![review-process](https://github.com/excellaco/open-cabinet/blob/master/documents/images/design_process.png)

By initially conducting usability testing with paper prototypes, the team learned what customers wanted early in the process, before investing time on development. From each round of testing, the Usability Tester discovered key insights that drove the next round of designs and development.

Following this human-centered design techniques ensured that:

* Design was based on an explicit understanding of users, obtained from crowdsourcing and user research.
* Users were involved throughout the design and development process, by allowing them to inform OpenCabinet's purpose, give feedback on design mock-ups, and interact with each version of the application.
* Design was driven and refined by user-centered evaluation through multiple rounds of usability testing.
* The process was iterative, with user feedback driving the next round of design and development activities.



###Development
Using the **Definition of Done** created in Sprint 0, the team prioritized code quality by including successful execution of [unit](https://github.com/excellaco/open-cabinet/tree/master/spec), [integration](https://github.com/excellaco/open-cabinet/tree/master/spec), and [acceptance tests](https://github.com/excellaco/open-cabinet/tree/master/features) and performing a code review before it was merged into master. These practices ensured that the application was stable for usability testing and allowed for constant refactoring and improvement of the code base without the fear of breaking core functionality. Even in a dynamic and fast-paced environment, the development team reacted to user feedback and implemented feature toggles, which allowed for various views of the data to be re-mixed to support further usability testing.

**`... and ended with "Ship It"`**


---
######The full open source technology stack can be seen [here](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md).




