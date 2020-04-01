# Capstone project proposal outline

Use the Markdown format to write and submit your project proposal.

_Markdown is a simple way to format plain text._  You can read [a detailed background about markdown here](https://daringfireball.net/projects/markdown/), and get [a quick reference and intro to markdown here](http://commonmark.org/help/).

Use the headings and notes below to guide your proposal.  Stick to these headings and include as much detail about what you want your project to do.

## Project overview

**_Where To Go_** is a Web App that allows poeple to find, share and plan trips.

## Application purpose

The App can be used by anyone who's interested in travelling and sharing or finding trip experiences and ideas. The visitors (or anonymous users) can brows and look for trips and see the details and comments for each trip. They can also sign in and log in as registered user. The registered users can do the same as the anonymous users and in addition they can create and update their own trips, add trips to their to-do-list and done-list. Admin users do all the above and manage other users account.
The trips are composed of stages with information about the distance between each stage and how to travel. Each stage has information about what to do and optional image.

Trips are organized in different categories:
* Trip type:
  + City trip
  + road trip
  + International trip
* Location:
  + Continant
  + country
  + region
  + city
* Trip type 2:
  + Advanturous
  + Cultural
  + Relaxing

## Front end

### Components build by hand
* Cards and list elements
* Comments
* Form group inputs (labels and input)
* Forms (user sign up, user log in, trip creation/update, stage creation/update)
* Header
* Footer
* Nav-bar with drop-down menu
* Search bar
* Trip and stage page
* Etc...

### Interactive elements to implements
* Alerts and notices displayed via either html or ajax request depending on the underlying request and dismissed manually or automatically after some time with JavasScript.
* Dropdown menu for logged user with links to account pages
* Delete button that will remove element from page (performed asynchronously via ajax request) and the database when deleted by user
* Drag and drop list to organize stages order in the trip update form
* Filtering searches by categories using JavaScript to hide or display items
* Real-time updated comments using ActionCable
* Display search results as either cards or lists by changing CSS classes
* CSS transitions and/or animations on appearing and disappearing elements

## Data structures and models

* User:
  + email
  + passowrd
  + name
  + has many trips
  + has many comments
  + has many trips through todolist
* Trip:
  + title
  + description
  + image
  + categories (1/2)
  + location
  + has many ordered stages
  + has many commnets
  + belongs to many users through todolist
* Stage:
  + title
  + belongs to one trip
  + image
  + geolocation
  + description
  + number
  + google maps direction results from previous stage (None if first stage and generated only if geolocation from previous stage change) 
  + mode of travel from previous stage (None if first stage)
  + has many comments
* Comment:
  + body
  + belongs to one user
  + belongs to one trip or stage
* ToDolist:
  + state (to do or done)

## Third party services

Include a list of all third party services that you envisage using in your project.  For each one, indicate what they will be used for.  These include:

* Ruby gems or JavaScript libraries outside of those bundled with Ruby on Rails by default.
  + carrierwave gem for image upload
  + figaro gem to store credential for AWS
  + fog-aws gem to store image uplaods on AWS
  + pg gem to use PostgreSQL database for production
  + kaminari gem for pagination
  + aasm gem for the ToDoList state
  + google_maps_service gem for google maps api
  + unsplash gem for unsplash api
* CSS frameworks
  + Bootstraps if needed
* Third party APIs
  + unsplash to provide random picture to use for trip or stage image
  + google maps api to calculate distance and directions between stages
* Deployment services, such as Heroku
  + heroku for deployement
  + AWS S3 bucket for upload storage of the deployed application
