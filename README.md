# ✨ Solid Rails App <!-- omit in toc -->

Web and REST API application made with [Ruby on Rails](https://guides.rubyonrails.org/) + [solid-process](https://github.com/B-CDD/solid-process).

## 🙌 Repository branches <!-- omit in toc -->

This repository has three branches:
1. [main](https://github.com/B-CDD/solid-rails-app/blob/main/README.md): `95%` Rails way + `5%` solid-process. (**📍 you are here**)
2. [vanilla-rails](https://github.com/B-CDD/solid-rails-app/blob/vanilla-rails/README.md): `100%` Rails way + `0%` solid-process.
3. [solid-process](https://github.com/B-CDD/solid-rails-app/blob/solid-process/README.md): `20%` Rails way + `80%` solid-process.

## 📢 Disclaimer <!-- omit in toc -->

The goal of this branch is to show how the `solid-process` can be progressively introduced into a Rails application (check out the [`User::Registration`](https://github.com/B-CDD/solid-rails-app/blob/main/app/models/user/registration.rb)).

You can use it only where you see fit, and you don't need to choose between one approach (Rails Way) or another (solid-process), as both can coexist in a complementary and friendly way.

## 🌟 Highlights of what solid-process can bring to you <!-- omit in toc -->

1. The [`solid-process`](https://github.com/B-CDD/solid-process) uses Rails's known components, such as ActiveModel attributes, validations, callbacks, and more. This way, you can use the same tools you are already familiar with.

2. A way for representing/writing critical system operations. It feels like having code that documents itself. You can see the operation's steps, inputs, outputs, side effects, and more in one place.

3. A less coupled codebase, given that this structure encourages the creation of cohesive operations (with a specific purpose), thus reducing the concentration of logic in ActiveRecord models.
    > e.g., several callbacks from the `User` model were replaced by the [`User::Registration`](https://github.com/B-CDD/solid-rails-app/blob/main/app/models/user/registration.rb) process.

4. Standardization of instrumentation and observability of what occurs within each process (Implement a listener to do this automatically and transparently for the developer [[1]](https://github.com/B-CDD/solid-rails-app/blob/main/config/initializers/solid_process.rb) [[2]](https://github.com/B-CDD/solid-rails-app/blob/main/lib/rails_event_logs_logger_listener.rb)). This will help you better understand what is happening within the system.
    <details>
    <summary><strong><a href="https://github.com/B-CDD/solid-rails-app/blob/main/app/models/user/registration.rb" target="_blank">User::Registration</a> event logs sample:</strong></summary>
    <pre>
    #0 User::Registration
    * Given(email:, password:, password_confirmation:)
    * Continue(user:) from method: create_user
    * Continue(account:) from method: create_user_account
    * Continue() from method: create_user_inbox
    * Continue() from method: create_user_token
    * Continue() from method: send_email_confirmation
    * Success(:user_registered, user:)
    </pre>
    </details>

5. The file structure reveals the system's critical processes, making it easier to understand its behavior and find where to make changes. Check out the [app/models](https://github.com/B-CDD/solid-rails-app/blob/main/app/models) directory.
    <details>
    <summary><code>app/models</code> file structure (checkout the <a href="https://github.com/B-CDD/solid-rails-app/blob/solid-process/app/models" target="_blank">solid-process</a> branch to see a more complete example):</summary>
    <pre>
    app/models/user
    └── registration.rb
    </pre>
    </details>

## 📚 Table of contents <!-- omit in toc -->

- [System dependencies](#system-dependencies)
- [Setup](#setup)
- [How to run the test suite](#how-to-run-the-test-suite)
- [How to run the application locally](#how-to-run-the-application-locally)
- [API Documentation (cURL examples)](#api-documentation-curl-examples)
  - [User](#user)
    - [Registration](#registration)
    - [Authentication](#authentication)
    - [Account deletion](#account-deletion)
    - [Access token updating](#access-token-updating)
    - [Password updating](#password-updating)
    - [Password resetting - Link to change the password](#password-resetting---link-to-change-the-password)
    - [Password resetting - Change the password](#password-resetting---change-the-password)
  - [Task List](#task-list)
    - [Listing](#listing)
    - [Creation](#creation)
    - [Updating](#updating)
    - [Deletion](#deletion)
  - [Task](#task)
    - [Listing](#listing-1)
    - [Creation](#creation-1)
    - [Updating](#updating-1)
    - [Deletion](#deletion-1)
    - [Marking as completed](#marking-as-completed)
    - [Marking as incomplete](#marking-as-incomplete)

## System dependencies
* SQLite3
* Ruby `3.2.3`
  * bundler `>= 2.5.6`

## Setup

1. Install system dependencies
2. Create a `config/master.key` file with the following content:
  ```sh
  echo 'a061933f96843c82342fb8ab9e9db503' > config/master.key

  chmod 600 config/master.key
  ```
3. Run `bin/setup`

## How to run the test suite

* `bin/rails test`

## How to run the application locally
1. `bin/rails s`
2. Open in your browser: `http://localhost:3000`

## API Documentation (cURL examples)

Set the following environment variables to use the examples below:

```bash
export API_HOST="http://localhost:3000"
export API_TOKEN="MY_ACCESS_TOKEN"
```

You can get the `API_TOKEN` by:
1. Using the below `User / Registration` request.
2. or performing the below `User / Authentication` request.
3. or copying the `access_token` from `Sign In >> Settings >> API` page.

### User

#### Registration

```bash
curl -X POST "$API_HOST/api/v1/users/registrations" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "email@example.com",
      "password": "123123123",
      "password_confirmation": "123123123"
    }
  }'
```

#### Authentication

```bash
curl -X POST "$API_HOST/api/v1/users/sessions" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "email": "email@example.com",
      "password": "123123123"
    }
  }'
```

#### Account deletion

```bash
curl -X DELETE "$API_HOST/api/v1/users/registrations" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Access token updating

```bash
curl -X PUT "$API_HOST/api/v1/users/tokens" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Password updating

```bash
curl -X PUT "$API_HOST/api/v1/users/passwords" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{
    "user": {
      "current_password": "123123123",
      "password": "321321321",
      "password_confirmation": "321321321"
    }
  }'
```

#### Password resetting - Link to change the password

```bash
curl -X POST "$API_HOST/api/v1/users/passwords/reset" \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "email@example.com"}}'
```

#### Password resetting - Change the password

```bash
curl -X PUT "$API_HOST/api/v1/users/passwords/reset" \
  -H "Content-Type: application/json" \
  -d '{
    "user": {
      "token": "TOKEN_RETRIEVED_BY_EMAIL",
      "password": "123123123",
      "password_confirmation": "123123123"
    }
  }'
```

### Task List

#### Listing

```bash
curl -X GET "$API_HOST/api/v1/task_lists" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Creation

```bash
curl -X POST "$API_HOST/api/v1/task_lists" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task_list": {"name": "My Task List"}}'
```

#### Updating

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/2" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task_list": {"name": "My List"}}'
```

#### Deletion

```bash
curl -X DELETE "$API_HOST/api/v1/task_lists/2" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

### Task

#### Listing

```bash
# ?filter=completed | incomplete

curl -X GET "$API_HOST/api/v1/task_lists/1/tasks" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Creation

```bash
curl -X POST "$API_HOST/api/v1/task_lists/1/tasks" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task": {"name": "My Task"}}'
```

#### Updating

```bash
# "completed": true | 1 | false | 0

curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d '{"task": {"name": "My Task", "completed": true}}'
```

#### Deletion

```bash
curl -X DELETE "$API_HOST/api/v1/task_lists/1/tasks/1" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Marking as completed

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1/complete" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```

#### Marking as incomplete

```bash
curl -X PUT "$API_HOST/api/v1/task_lists/1/tasks/1/incomplete" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_TOKEN"
```
