# WishPool

## WishPool Thinking - Where Your Dreams Come True

## API

| Method | Path | Description |
| :-- | :-- | :-- |
| POST | /auth | Creates a new account. Required params: { **user**, **password**, **password_confirmation**} |
| POST | /auth/sign_in | Signs in a user. Required params: { **email**, **password** }. Headers will contain **access-token**, **client** and **expiry** fields required for further use |
