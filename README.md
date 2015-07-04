https://opencabi.net

[![Build Status](https://magnum.travis-ci.com/excellaco/open-cabinet.svg?token=ztW2D3QGwNvKdJWTdpNu)](https://magnum.travis-ci.com/excellaco/open-cabinet)
[![Code Climate](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/gpa.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/feed)
[![Test Coverage](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/coverage.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/coverage) 

---
**`it began with crowdsourcing ...`**

![open-cabinet logo](https://github.com/excellaco/open-cabinet/blob/master/app/assets/images/open-cabinet.png)

##Approach 
**Excella Consulting** followed an agile development framework to build **OpenCabinet** in an iterative, incremental manner.  The cross-functional team, comprised of analysts, designers, and developers, began with Sprint 0, followed by two-day sprints that consisted of a daily stand-up and ended with a quick review and retrospective.  

The team consisted of the following roles: 

* Product Manager
* Technical Architect
* User Researcher/Usability Tester
* Writer/Content Designer
* Visual Designer
* Front-End Web Developers
* Back-End Web Developers
* DevOps Engineer
* Business Analyst


The self-organized team not only fulfilled their individual roles in the design and development process, but also helped where needed to deliver a quality product.  With the Product Manager leading the effort to ensure the vision and delivery of the product, the team was equipped to respond quickly to changing priorities and address findings discovered during usability testing. Utilizing **[GitHub issues](https://github.com/excellaco/open-cabinet/issues)**, the team created and groomed a [backlog](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=label%3A%22user+story%22+), discussed [design decisions](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=+label%3Adesign+), and tracked [bugs](https://github.com/excellaco/open-cabinet/issues?utf8=%E2%9C%93&q=+label%3Abug+).

---
##Sprint 0
The team used an internal Slack channel to **[crowdsource](https://github.com/excellaco/open-cabinet/blob/master/documents/images/crowdsourcing.png)** ideas for the application, review the suggestions, and discuss the feasibility of delivering a product in the given timeframe from both design and development perspectives. With an initial idea of "[my medicine cabinet](https://github.com/excellaco/open-cabinet/blob/master/documents/design/brainstorming.md)" agreed upon, the team were ready to begin.  

During Sprint 0, the team achieved four goals:
 
* Explored users’ **needs and reactions**
* Determined the **applications’ value**
* Decided what **technologies** to use
* Set up the **development environment**

###Needs and Reactions
The team interviewed potential users to understand their desired needs. Through this research, we discovered that users’ primary goal was to see medical interactions, which led us to modify our initial concept to focus on this feature. We created **[Personas](https://github.com/excellaco/open-cabinet/blob/master/documents/design/personas.md)** to represent different user types, and included one in our **[short-form creative brief](https://github.com/excellaco/open-cabinet/blob/master/documents/design/short_form_creative_brief.md)**, which we read aloud each morning in stand-up. These tools informed the design and features included in the **[Minimal Viable Product](https://github.com/excellaco/open-cabinet/labels/MVP)** (MVP).

###Application Value
**[Competitive analysis](https://github.com/excellaco/open-cabinet/blob/master/documents/design/market_research.md)** revealed that many applications show medical interactions, but our team decided to design and build an application that was simple, easy to use, and incorporated a pleasant user experience. A roadmap for future enhancements, indicated in our **[Product Tree](https://github.com/excellaco/open-cabinet/blob/master/documents/design/product_tree.md)** will further distinguish OpenCabinet from the current marketplace.


###Technologies
The development team determined the best technologies and tools for developing the prototype through collaboration, research, and evaluation. With a focus on open source, rapid prototyping, and code quality, the team decided to use **Ruby on Rails**. 

###Development Environment
With the core technology agreed upon, the team set up a development environment leveraging **Docker**, **Vagrant** and **Chef**. By virtualizing the operating system and providing a [living set of instructions](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/installation.md), team members quickly got their environments up in a consistent manner with a prescribed set of required infrastructure. Combined with **GitHub’s version control**, the base for intuitive versioning and consistent baselines for development were set. The team built a continuous integration and delivery pipeline  to deploy a skeleton Rails application, which was deployed onto the PaaS provider **Heroku** to allow for scalability. Through the use of **Travis** the chosen continuous integration server, code was continuously deployed after passing a series of quality assurance checks.

Against every pull request and push to the master branch, Travis-CI automatically ran:

* **RSpec** for unit and integration tests
* **Cucumber/Capybara** for automated acceptance tests
* **Teaspoon/Mocha** for testing JavaScript
* **Rubocop** for static code analysis
* **Brakeman/Code Climate** for security static analysis
* **Code Climate** for code quality metrics
* **SauceLabs** for multiple browser testing

**Travis** was also tightly integrated with GitHub. When performing code reviews on a pull request, the reviewer could see the status of those tests to ensure that along with a visual inspection of the code, all tests also passed. These practices instilled confidence that functional code was being deployed to production.
The final integration points were to secure the application and bring visibility to the health of the application. **SSL certificates** were acquired and set-up to ensure user security. **Slack**, which served as the team’s collaboration forum, was configured to automatically notify the team of changes to the repository, and denoted key checkpoints in the continuous integration process.  The GitHub repository housed Badges, which  provided visibility to the code’s test coverage, quality, and build status, while monitoring tools, **New Relic**, **Log Entries**, **Google Analytics**, and **Air Brake**, captured and alerted key metrics and issues with the system.

The Front-End Web Developer established a lightweight framework that supported OpenCabinet's design patterns and style guide, and the development team implemented tools that created structure, but were flexible to meet mobile-responsive design needs.

* For presentation, **Sass**, **Bourbon**, and **Neat** were used to lay the foundation
* For interaction, **T3** was used as the JavaScript framework, and **Teaspoon/Mocha** for testing JavaScript code
* For post processing, **SauceLabs** was used to run acceptance tests against various browsers and **AutoPrefixer** to ensure that vendor prefixes were added to CSS to do the same
* For usability testing, **Flip** implemented feature toggling to support A/B testing

---
##Sprint 1 + 2

###Design
Sprint 1 resulted in two artifacts: 

* A **[style guide](https://github.com/excellaco/open-cabinet/blob/master/documents/design/style_guide.md)** containing guidance on how to use typography, color, and address visual elements to ensure visual consistency  
* Initial **[prototype mock-ups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_1.md)** for two different layouts

The mock-ups were used during usability testing. Unanimously, [users](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_1_testing.md) preferred the “cabinet” option, which is represented in the final prototype along with a mobile version.

During Sprint 2, user feedback was incorporated into a [second version of mockups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_2.md). This was tested with users to learn that key elements (e.g. navigation and search) were [not received well](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_2_testing.md). We created issues in GitHub addressing these pain points, which allowed developers to make iterative changes to the application, which were then retested in subsequent  rounds of usability testing.


###Development
During Sprints 1 and 2, the development team developed the foundation of the application. Following a strategy of short-lived branches, and continuous integration of small features into the master branch, the team began initial implementation of the API integrations keeping performance in mind by caching the API requests. This set the framework to get features out quickly for end user testing when the designs were complete, which ultimately allowed for constant feedback and improvements of the product.


---

##Sprint 3 + 4

###Design
The MVP was completed in Sprints 3 and 4, and we began performing usability testing on a functioning application.With the new interactions in place, which were lacking in paper prototype testing, we discovered that users were confused by how medicine selection worked. The interaction visualizations were then re-evaluated and we created alternative options to test with users using a [feature toggle](https://opencabi.net/features).

By initially conducting usability testing with paper prototypes, an idea of what customers wanted was formulated early, before investing time on development. From each round of testing, key insights were discovered that helped drive the next round of designs and development.
Following this human-centered design approach ensured that:
1. Design was based on an explicit understanding of users, obtained from crowdsourcing and user research
2. Users were involved throughout the design and development process, by allowing them to inform OpenCabinet's purpose, give feedback on design mockups, and interact with each version of the application
3. Design was driven and refined by user-centered evaluation through usability testing
4. The process was iterative with user feedback driving the next round of design and development activities.



###Development
The team agreed on a definition of done, which prioritized code quality by including successful execution of [unit](https://github.com/excellaco/open-cabinet/tree/master/spec), [integration](https://github.com/excellaco/open-cabinet/tree/master/spec), and [acceptance tests](https://github.com/excellaco/open-cabinet/tree/master/features) and performing a code review before it was merged into master. his ensured that the application was stable for usability testing and allowed for constant refactoring and improvement of the code base without the fear of breaking core functionality. Even in a dynamic and fast-paced environment, the development team  reacted to user feedback and implemented feature toggles which allowed for various views of the data to be re-mixed to support further usability testing.

**`... and ended with "Ship It"`**


---
The full open source technology stack can be seen [here](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md).




