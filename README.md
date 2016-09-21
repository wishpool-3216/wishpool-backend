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
Tests must pass. Rails tests go in `spec/` (Using RSpec), and fixtures in 'spec/fixtures/'. Alternatively use `FactoryGirl` to generate test data
To run, just type `bundle exec rspec` from the root directory

#### API
Return values generally follow columns in the database. Additional fields are listed explicitly in the API documentation.
All DateTimes are formatted YYYY-MM-DDThh:mm:ss:sTZD

* `User`
    * id: int. Identifying id of the resource
    * provider: string. Generally `facebook`.
    * uid: string. Generally the user's Facebook uid
    * name: string.
    * created_at: DateTime
    * birthday: DateTime
* `Gift`
    * id: int. Identifying id of the resouce
    * name: string. Name of the Gift.
    * expected_price: float. Expected price of the resource
    * created_at: DateTime
    * creator_id: int. id of the creating `User`
    * recipient_id: int. id of the receiving `User`
    * publicity: string. Either `Public` or `Private`
    * expiry: DateTime
    * sum_contributions: float. Sum of all the contributions given
* `Contribution`
    * id: int
    * gift_id: int. id of the associated `Gift`
    * amount: float
    * created_at: int. id of the associated `User`

| Method | Path | Description | Returns |
| :-- | :-- | :-- | :-- |
|  | **USER** |  | |
| POST | /auth | **UNUSED** Creates a new account. Required params: { **user**, **password**, **password_confirmation**} | |
| POST | /auth/sign_in | **UNUSED** Signs in a user. Required params: { **email**, **password** }. Headers will contain **access-token**, **client** and **expiry** fields required for further use | |
| POST | /auth/facebook/callback | Call this after hitting `FB.login` to retrieve access token in the header to continue with your session. Will also return the associated User's details in JSON format. Required params: { **uid**, **access_token**, **expires\_in** }. Note that a a minimum, you **must** include user\_birthday and user\_friends scopes | |
| DELETE | /auth/sign_out | Invalidates a user's token. Requires auth. | |
| GET | /api/v1/users/:id | Gets the User associated with the given ID. Also yields an array gifts which contains the gifts that this user is **receiving** | `user_columns` + an array `gifts` containing the gifts this `User` is receiving |
| PATCH | /api/v1/users/:id | Updates the User associated with the given ID | |
| GET | /api/v1/users/:id/friend_birthdays | Returns an array of users with their relevant information sorted by their birthdays in upcoming order. Requires auth. | |
| GET | /api/v1/users/:id/contributions_made | Returns an array of the contributions which the user has made | [ {`contribution_columns`}, ... ] |
| GET | /api/v1/userse/:id/gifts_contributing | Returns an array of the gifts which the user is contributing to | [{`gift_columns`}, ...] |
||**GIFTS**|| |
| GET | /api/v1/gifts/:id | Gets the gift data with the correct id | {`gift_columns`, `contributions`: [{`contribution_columns`},...], `recipient`: {`user_columns`} } |
| GET | /api/v1/users/:user_id/gifts | Gets all the gifts that a particular user is receiving | [{`gift_columns`}, ...] |
| POST | /api/v1/users/:user_id/gifts | Creates a new gift for user (indicated by user\_id) to receive. Requires auth. Required params: {**name** (Name of Gift), **publicity** (Public / Private)}. Permitted params: { **expected\_price**, **expiry**, **description** } | |
| PATCH | /api/v1/gifts/:id | Updates the gift data with the relevant id. Permitted params: see above. Requires auth. | |
| DELETE | /api/v1/gifts/:id | Deletes the gift with the id. Requires auth. | |
||**CONTRIBUTIONS**|| |
| GET | /api/v1/gifts/:gift_id/contributions | Returns all the contributions associated to a particular gift | [{`contribution_columns`}, ...] |
| GET | /api/v1/contributions/:id | Returns the contribution with the particular id | `contribution_columns`, `gift`: {`gift_columns`}, contributor: {`user_columns`} |
| POST | /api/v1/gifts/:gift_id/contributions | Adds a new contribution to the gift given by **gift\_id**. Requires auth. Required params: { **amount** } | |
| PATCH | /api/v1/contributions/:id | Updates the contribution with the given id. Requires auth. Required params: { **amount** } | |
| DELETE | /api/v1/contributions/:id | Deletes the contribution with the given id. Requires auth. | |
