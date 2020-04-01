# WherToGo App

**_Where_ To _Go_** is a Web App that allows poeple to find, share and plan trips.

The App can be used by anyone who's interested in travelling and sharing or finding trip experiences and ideas. The visitors (or anonymous users) can brows and look for trips and see some details and the comments of each trip. Once a user register to the app, he can see all the trips and trips' stages content and user profils. The registered user can also create and update their own trips and trips' stages and manage their todo list, where a trip can marked as to do, in progress or done. Admin users can edit all app content and manage the users list.

## App Set up

### Develpment

* Download project
* Install gems
  ```shell
  bundle update
  ```
* Create and seed development database
  ```shell
  rails db:migrate
  rails db:seed
  ```
* Run the tests
  ```shell
  rails test
  ```
* Start the server
  ```shell
  rails server
  ```

### Figaro

The app is configured to use _Figaro gem_ to keep secrets in a file ignored by git. The secrets are stored in environment variables and are easily send to Heroku in one command.

```shell
figaro heroku:set -e production
```
See [Figaro gem](https://github.com/laserlemon/figaro) for more info.

### Google Maps API

The app is using the _Google Maps Services API_ and thus need a valid API Key in order to work. If you don't have one, check out the _Google Maps Services_ [Get Started](https://developers.google.com/maps/gmp-get-started).

Four services are used:
* [Directions API](https://developers.google.com/maps/documentation/directions/start)
* [Maps Embeded API](https://developers.google.com/maps/documentation/embed/start)
* [Maps JavaScript API](https://developers.google.com/maps/documentation/javascript/tutorial)
* [Places API](https://developers.google.com/places/web-service/intro)

To set up _Google Maps Services_ in the app you have to create two environment variables.

* `GOOGLE_API_SERVER_KEY` containing the API Key used to call the _Directions API_ from the server
* `GOOGLE_API_CLIENT_KEY` containing the API Key used to call the _Maps Embeded API_, the _Maps JavaScript API_ and the _Places API_ from the client

You can use the same key for both, if you want, as long as you authorize it call all four APIs.


### Production

Once the app is ready to be send to production, preceed to the following steps.

#### ActionCable and ActiveJob queue

The _ActionCable_ server will run in-app and need a **Redis** server as subscription adapter. The _ActiveJob_ queue is handled by **Resque** and also need a **Redis** server (can be the same if your are limited in resources).
* Set an environment variable `REDIS_URL` containing the url of a Redis server. This will be used for both _ActionCable_ and **Resque** configuration, see `./config/cables.yml`, `./config/initializers/resque.rb` and `./config/initializers/redis.rb`.
* You also will have to set the _ActionCable_ URL and allowed request origins
  ```ruby
  # `./config/environments/production.rb`
  Rails.application.configure do
    ...

    config.action_cable.url = 'wss://your-app-domain.com/cable' 
    config.action_cable.allowed_request_origins = [ 'https://your-app-domain.com/', 'http://your-app-domain.com/' ]

    ...
  end
  ```

#### CarrierWave file upload

Because of its deployement to **Heroku**, this app is configurated to upload the images uploaded with the _AvatarUploader_ and _ImageUploader_ to an **AWS S3 Bucket**. Thus, for this next steps you will need a **AWS S3 Bucket** and **AWS IAM User** with valid _access key ID_ and _secret access key_.

Once you have all the above mentioned resources ready, you only have to set few environment variables.

* The `AWS_BUCKET` containing the name of your **Bucket**
* The `AWS_ACCESS_KEY` containing the _access key id_ of your **IAM user**
* The `AWS_SECRET_KEY` containing the _secret access key_ of your **IAM user**
* The `AWS_BUCKET_REGION` containing your **Bucket** region

Here are some walkthrough to help you out:
* [Switching CarrierWave to use S3 with Heroku and localhost](https://blog.thefirehoseproject.com/posts/switching-carrierwave-to-use-s3-with-heroku-and-localhost/)
* [Fixing Rails + Carrierwave + Amazon S3 403 Forbidden Error](https://www.bitesite.ca/blog/fixing-rails-carrierwave-amazon-s3-403-forbidden-error)

#### Postgres database

The app need a Postgres database to run in production.
You can set the following environment variables to configure the `./config/database.yml` file:

* `POSTGRESS_USERNAME` containing the database user name
* `POSTGRESS_SECRET` containing the database secret

#### Test the production server localy

* Create an adequate role in your local Postgres database and create your database
  ```shell
  RAILS_ENV=production rails db:setup
  ```
* Pre-compile your assets
  ```shell
  RAILS_ENV=production rails assets:precompile
  ```
* Create and run a `run-production.sh` file (add it to your .gitignore to avoid commiting secrets)
  ```shell
  export RAILS_SERVE_STATIC_FILES=true
  export SECRET_KEY_BASE=< SECRET > # SECRET generated by the command rails secret
  rails server --environment production
  ```

Don't forget to set and run a local **Redis** server if needed.

#### Deployement with Heroku

* Create a new **Heruko app**
  ```shell
  heroku create
  ```
* Provision the newly created app with a **Redis** add on, the one you prefer. In this example, the [Heroku Redis](https://elements.heroku.com/addons/heroku-redis) add on is used. The advantage with **Heroku Redis** is that it automatically create an `REDIS_URL` variable.
  ```shell
  heroku addons:create heroku-redis:hobby-dev -a your-app-name
  ```
* Set _ActionCable_ URL and allowed origins if not already done
* Set your environment variables with **Figaro**
  ```shell
  figaro heroku:set -e production
  ```
* Push your master branch to **Heroku**
  ```shell
  git push heroku master
  ```
* Create and seed the database
  ```shell
  heroku run rails db:migrate
  heroku run rails db:seed
  ```
* Scale up job worker
  ```shell
  heroku ps:scale worker=1
  ```

Your app is now up and running!


## Context

This Rails app was created as Capstone project for the Web Application Development programm of the EPFL Extension School.

The app was built based one the `capstone_proposal_outline.markdown` present in this folder.

A running version of the app can be found at: https://agile-cove-74127.herokuapp.com/

### Project Autoassessment 
#### Achieved Goals

I tink that I did pretty much everything that I wanted to do. The project became a bit more complexe that I expected. I implemented all the data models, their associations and the logic that I wanted to have. Regarding the front-end, I created all the needed elements and useful features. I also created new features that I did not think to do myself at the beginning due to the lack of convincing pre-existing solutions, such as the dynamic location select form element.

The overall app work as intended with a pleasant UI which I think is a success.

#### Difficulties

I had several difficulties since the project turned out to be less straight forward than expected and I stumbled on some things that I never tried before.

**_Google Maps Services API_** was definitly one of biggest difficulty. The first problem was to understand how much it would coast me and if I was risking give all my spearings to Google ^^'. Afterward, since it provides a loat features, I needed to find out how to do the specific things that I needed. In top of that, the _Directions API_ results and _Maps JavaScript API_ are not compatible out of the box. I, thus, had to find a way make it work. Fortunately, as for allmost all your questions, somebody allready asks this and someone had the solution.

**The Drag and Drop Form** was not as challenging as I thaught, although it required me quit some time and trial and error to complete it, especially because of the many element presents in the draggable element. It has a very good MDN documentation about it.

**_ActionCable_ and _ActiveJob_** for the live comments gave a bit of work to implement. I had to grasp the concept of Websockets that I only knew by name. Subsequantly, I needed to learn how to implement it in an app. This was not easy as I was not able to run the action-cable-example given on the Rails Guides. I'm still not able to do it but, eventually, I tried to implement it in my app without **Redis** and by running the _ActionCable_ server within the app. This worked perfectly and I was very happy but still anxious thinking about deployement for which I would need **Redis**. I was happily surprised that it went quit smoothly.

In addition to these main points, I had bits of difficulties here and there, that slowed me down. The Stage model is a good example with complicated logic (i.e. reordering the stages) that might be refactored in a simpler way.

#### Changes

I did not implement few features or solutions from the proposal for various reasons that I'll list here:

* **"Display search results as either cards or lists by changing CSS classes"** 
  I decided not to implement the functionality because I thaught it would not be useful and would not really improve the UI.
* **"aasm gem for the ToDoList state"** 
  I did not use the gem **AASM** do define the ToDo model status attribute because I thaught that it was not worth it as the ToDo state change is really simple and basic.
* **"unsplash to provide random picture to use for trip or stage image"** 
  Because the combination of **CarrierWave** and _Unsplash_ could not, as far as I know, satisfy the _Unsplash API_ guidelines without including to muich complexity I decided to simply not use it.
* **"Stage model geolocation attribute"** 
  For simplicity and to avoid using too many _Google Maps Services_ to spare the monthly free credits, I chose to retrieve the full address for the stage and use it to get directions.
