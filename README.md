# WishPool [![Build Status](https://travis-ci.org/wishpool-3216/wishpool-backend.svg?branch=master)](https://travis-ci.org/wishpool-3216/wishpool-backend) [![Coverage Status](https://coveralls.io/repos/github/wishpool-3216/wishpool-backend/badge.svg?branch=master)](https://coveralls.io/github/wishpool-3216/wishpool-backend?branch=master)

## WishPool Thinking - Where Your Dreams Come True

## Setup
#### Requirements
* Ruby. RVM is suggested.
  * `gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3`
  * `\curl -sSL https://get.rvm.io | bash -s stable --ruby`
* Bundler.
  * `gem install bundler`
* postgres

#### Actual setup
* Go to your wishpool path
* `bundle install`
* `rake db:create db:migrate`
* `bundle exec rails s` Your server is running! Access at `localhost:3000`
* `./launch_https` To run with SSL, then access at `https://localhost:3000`

## Contributing

#### Testing
Tests must pass. Rails tests go in `spec/` (Using RSpec), and fixtures in 'spec/fixtures/'
To run, just type `bundle exec rspec` from the root directory

#### API

| Method | Path | Description |
| :-- | :-- | :-- |
|  | **USER** |  |
| POST | /auth | **UNUSED** Creates a new account. Required params: { **user**, **password**, **password_confirmation**} |
| POST | /auth/sign_in | **UNUSED** Signs in a user. Required params: { **email**, **password** }. Headers will contain **access-token**, **client** and **expiry** fields required for further use |
| POST | /auth/facebook/callback | Call this after hitting `FB.login` to retrieve access token in the header to continue with your session. Will also return the associated User's details in JSON format. Required params: { **uid**, **access_token**, **expires\_in** }. Note that a a minimum, you **must** include user\_birthday and user\_friends scopes |
| DELETE | /auth/sign_out | Invalidates a user's token. Requires auth. |
| GET | /api/v1/users/:id | Gets the User associated with the given ID. Also yields an array gifts which contains the gifts that this user is **receiving** |
| PATCH | /api/v1/users/:id | Updates the User associated with the given ID |
| GET | /api/v1/users/:id/friend_birthdays | Returns an array of users with their relevant information sorted by their birthdays in upcoming order |
||**GIFTS**||
| GET | /api/v1/gifts/:id | Gets the gift data with the correct id |
| GET | /api/v1/users/:user_id/gifts | Gets all the gifts that a particular user is receiving |
| POST | /api/v1/users/:user_id/gifts | Creates a new gift for user (indicated by user\_id) to receive. Requires auth. Required params: {**name** (Name of Gift), **publicity** (Public / Private)}. Permitted params: { **expected\_price**, **expiry**, **description** } |
| PATCH | /api/v1/gifts/:id | Updates the gift data with the relevant id. Permitted params: see above. Requires auth. |
| DELETE | /api/v1/gifts/:id | Deletes the gift with the id. Requires auth. |
||**CONTRIBUTIONS**||
| GET | /api/v1/gifts/:gift_id/contributions | Returns all the contributions associated to a particular gift |
| GET | /api/v1/contributions/:id | Returns the contribution with the particular id |
| POST | /api/v1/gifts/:gift_id/contributions | Adds a new contribution to the gift given by **gift\_id**. Requires auth. Required params: { **amount** } |
| PATCH | /api/v1/contributions/:id | Updates the contribution with the given id. Requires auth. Required params: { **amount** } |
| DELETE | /api/v1/contributions/:id | Deletes the contribution with the given id. Requires auth. |
