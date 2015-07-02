https://opencabi.net

[![Build Status](https://magnum.travis-ci.com/excellaco/open-cabinet.svg?token=ztW2D3QGwNvKdJWTdpNu)](https://magnum.travis-ci.com/excellaco/open-cabinet)
[![Code Climate](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/gpa.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/feed)
[![Test Coverage](https://codeclimate.com/repos/5582a4ef695680215a031469/badges/876970494b7eba49266f/coverage.svg)](https://codeclimate.com/repos/5582a4ef695680215a031469/coverage) 

---

![open-cabinet logo](https://github.com/excellaco/open-cabinet/blob/master/app/assets/images/open-cabinet.png)

##Product Inception 
Excella built **OpenCabinet** using **Scrum** starting with Sprint 0, followed by two-day sprints that began with a daily stand-up and ended with a quick review and retrospective that included both the design and development teams.  

The team consisted of the following roles: 

* Product Manager
* Writer/Content Designer
* User Researcher/Usability Tester
* Visual Designer
* Technical Architect
* Back-End Web Developers
* Front-End Web Developers
* DevOps Engineer

The self-organized team not only fulfilled their individual roles in the design and development process, but also helped where needed to deliver a quality product.  With the Product Manager leading the effort to ensure the vision and delivery of the product, the team was equipped to respond quickly to changing priorities and address findings discovered during usability testing. Utilizing **[GitHub issues](https://github.com/excellaco/open-cabinet/issues)**, the team created and groomed a [backlog](https://github.com/excellaco/open-cabinet/labels/user%20story), discussed [design decisions](https://github.com/excellaco/open-cabinet/labels/design), and tracked [bugs](https://github.com/excellaco/open-cabinet/labels/bug).

---
##Sprint 0
After using an internal Slack channel to **[crowdsource](https://github.com/excellaco/open-cabinet/blob/master/documents/images/crowdsourcing.png)** ideas for the application, the design and development teams worked together to discuss the suggestions and discuss feasibility of delivering a product in the given timeframe from both perspectives.  With an initial idea of "[my medicine cabinet] (https://github.com/excellaco/open-cabinet/blob/master/documents/design/brainstorming.md)" agreed upon, the teams were ready to begin.  

During Sprint 0, four goals were achieved: 

* Determine the application's purpose
* Explore the needs and reactions of potential users
* Determine what technologies to use
* Set up the development environment 

###Design
To understand potential customers’ needs, users were interviewed and it was discovered that their primary goal was to see medicine interaction.  This led to the initial concept being modified to focus on user feedback. Even though **[competitive analysis](https://github.com/excellaco/open-cabinet/blob/master/documents/design/market_research.md)** showed that many applications already displayed medicine interactions, the goal was to design and build an application that solved problems that were lacking in these existing tools.
  
In order to accomplish this, several **human centered design techniques and tools** were utilized to define the prototype:

* **[Personas](https://github.com/excellaco/open-cabinet/blob/master/documents/design/personas.md)** represented different user types
* **[Short-form creative briefs](https://github.com/excellaco/open-cabinet/blob/master/documents/design/short_form_creative_brief.md)** of a persona were read aloud each stand-up to understand the target audience the application was being for
* The **[Product Tree](https://github.com/excellaco/open-cabinet/blob/master/documents/design/product_tree.md)** was built to have a roadmap for future enhancements that would distinguish OpenCabinet and give the development team an idea of what to build for

These tools allowed the team to envision a specific user who would benefit from the finalized product, and drove both the design and functionality decisions in determining the initial **[Minimal Viable Product](https://github.com/excellaco/open-cabinet/labels/MVP)** (MVP). 

###Development
The development team in parallel, through collaboration, research, and evaluation determined the best technologies and tools for developing the prototype.  With a focus on open source, rapid prototyping, and code quality, the team decided to use **Ruby on Rails**.  With the core technology agreed upon, a development environment leveraging **Vagrant** and **Chef** was set-up.  By virtualizing the operating system and providing a [living set of instructions](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/installation.md), team members were able to quickly get their environments up in a consistent manner with a prescribed set of required infrastructure.  Combined with GitHub’s version control, the base for intuitive versioning and consistent baselines for development were set.

Next a continuous integration and delivery pipeline was built to deploy a skeleton Rails application.  The application was deployed onto the PaaS provider **Heroku** to allow for scalability.  Through the use of **Travis-CI**, the chosen continuous integration server, code could be continuously deployed after passing a series of quality assurance checks.  

Against every pull request and push to the master branch, Travis-CI automatically ran:

* **RSpec** for unit and integration tests
* **Cucumber/Capybara** for automated acceptance tests
* **Teaspoon/Mocha** for testing JavaScript
* **Rubocop** for static code analysis
* **Brakeman/Code Climate** for security static analysis
* **Code Climate**’s for code quality metrics
* **SauceLabs** for multiple browser testing  

Travis-CI was also tightly integrated with GitHub.  When performing code reviews on a pull request, the reviewer could see the status of these tests to ensure that along with a visual inspection of the code that all tests also pass.  All of this helped instill confidence that functional code is being deployed to production.  

The final integration points were to secure the application and bring visibility to the health of the application.  **SSL certificates** were aquired and set-up to ensure user security.  While **Slack**, in addition to serving as the team’s collaboration forum, was configured to automatically notify the team of changes to the repository, as well as denote key checkpoints in the continuous integration process. Badges were added to the GitHub repository to provide visibility to the code’s test coverage, quality, and build status.  Monitoring tools, **New Relic**, **Log Entries**, **Google Analytics**, and **Air Brake**, were set-up to capture and alert on key metrics and issues with the system.

For front-end development, a framework was established that would support OpenCabinet's design patterns and style guide. The team implemented tools that provided a lightweight framework that created structure, but was flexible to meet design needs, and allow for easy implementation of a mobile first responsive design. 

* For presentation, **Sass** along with **Bourbon** and **Neat** were used to lay the foundation 
* For interaction, **T3** was used as the JavaScript framework, and **Teaspoon**/ **Mocha** for testing JavaScript code 
* For post processing, **SauceLabs** was used to run acceptance tests against various browsers and **AutoPrefixer** to ensure that vendor prefixes were added to CSS to do the same  
* For usability testing, **Flip** implemented feature toggling to support A/B testing  

---
##Sprint 1 + 2

###Design
Sprint 1 resulted in two artifacts: 

* A **[style guide](https://github.com/excellaco/open-cabinet/blob/master/documents/design/style_guide.md)** containing guidance on how to use typography, color, and address visual elements to ensure visual consistency  
* Initial **[prototype mock-ups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_1.md)** in two different layouts

The latter was employed during usability testing. Unanimously, [users](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_1_testing.md) preferred the “cabinet” option, which is represented in the final prototype along with a mobile version.

During Sprint 2, user feedback was incorporated into a [second version of mockups](https://github.com/excellaco/open-cabinet/blob/master/documents/design/design_concept_2.md).  This was tested with users to learn that key elements (e.g. navigation and search features) were [not received well](https://github.com/excellaco/open-cabinet/blob/master/documents/design/round_2_testing.md) so several key design changes were made to help address these pain points.  This time around instead of having to modify mock-ups again, issues were created in GitHub so developers could make take the feedback and make changes immediately to allow usability testing on a functioning application so the users could also react to interactions. 

###Development

During Sprint 1 and 2, the development team began developing the foundation of the application.  Following a strategy of short-lived branches, and continuous integration of small features into the master branch, the team was able to begin initial implementation of the API integrations.  This would set the framework to get features out quickly for end user testing when the designs were complete, which ultimately allowed for constant feedback and improvements of the product.  

---

##Sprint 3 + 4

###Design
In sprint 3 and 4, development of the application was at a point where users could start using with the actual application. With the new interactions in place, which were lacking in paper prototype testing, it was discovered that customers were confused by how medicine selection worked. The interaction was then reevaluated and a few alternative options were created to test with users using a [feature toggle](https://opencabi.net/features). 

By conducting usability testing early with paper prototypes, an idea of what customers wanted was formulated early before investing time on development. From each round of testing key insights were discovered that helped drive the next round of designs and development. 

Following this approach ensured that: 

1. Design was based on an explicit understanding of users, obtained from crowdsourcing and user research
2. Users were involved throughout the design and development process, by allowing them to inform OpenCabinet's purpose, give feedback on design mockups, and interact with each version of the application
3. Design was driven and refined by user-centered evaluation through usability testing
4. The process was iterative with user feedback driving the next days design and development activities.

###Development
With a team agreement on the definition of done, which includes having [unit](https://github.com/excellaco/open-cabinet/tree/master/spec), [integration](https://github.com/excellaco/open-cabinet/tree/master/spec), and [acceptance tests](https://github.com/excellaco/open-cabinet/tree/master/features) done along with a code review before code can be merged into master, code quality was the first priority.  In a dynamic and quickly moving environment, this ensured that the prototype was stable for usability testing and allowed for constant refactoring and improvement of the code base without the fear of breaking core functionality. This allowed the development team to react to user feedback and implement feature toggles quickly during sprint 3 and 4, which allowed for various views of the data to be readjusted based on the day's usability testing in order to support further usability testing.

---
The full open source technology stack can be seen [here](https://github.com/excellaco/open-cabinet/blob/master/documents/technical/technology_stack.md).




