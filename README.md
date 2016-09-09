# WishPool

## WishPool Thinking - Where Your Dreams Come True

## Setup
#### Requirements
* Ruby. RVM is suggested.
  * `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`
  * `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
* Bundler.
  * `apt-get install ruby-bundler`
* postgres
* Node
  * `apt-get install nodejs-legacy`
* Bower
  * `npm install -g bower`

#### Actual setup
* Go to your wishpool path
* `bundle install`
* `rake db:create db:migrate`
* `rails s` Your server is running! Access at `localhost:3000`

#### Adding components
Bower components are added through `./Bowerfile`

After adding components, run `rake bower:install`, then require the appropriate files to `app/assets/javascripts/application.js` and `app/assets/stylesheets/application.css` (See `application.js` require angular/angular for an example). Note: files are saved in `vendor/assets/bower_components`

## API

| Method | Path | Description |
| :-- | :-- | :-- |
|  | **USER** |  |
| POST | /auth | **UNUSED** Creates a new account. Required params: { **user**, **password**, **password_confirmation**} |
| POST | /auth/sign_in | **UNUSED** Signs in a user. Required params: { **email**, **password** }. Headers will contain **access-token**, **client** and **expiry** fields required for further use |
| GET | /auth/facebook/callback | Call this after hitting `FB.login` to retrieve access token in the header to continue with your session. Will also return the associated User's details in JSON format |
| GET | /api/v1/users/:id | Gets the User associated with the given ID |
| PATCH | /api/v1/users/:id | Updates the User associated with the given ID |
