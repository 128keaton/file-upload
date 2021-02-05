#  ActiveStorage File Upload in Rails


## Prerequisites

### *Development Environment Setup*
Please make sure you have setup your development environment following [these](https://human-se.github.io/rails-demos-n-deets-2021/demos/development-environment/) instructions.

As a result, you should have the following installed on your development machine:

* Ruby 2.7.2
  * Rails 6+
* Postgres
* Yarn (or npm)

If the above is all installed and working properly, you are ready to move to the next step.

## Setup

### Step 1: Clone the GitHub Repo
First, clone the base repository located like this:

```shell
git clone https://github.com/128keaton/file-upload
```

### Step 2: Switch to the `main` Branch
The main branch contains the base application to begin adding file uploads.
This branch contains the migrations necessary for ActiveStorage

```shell
git switch main
```

### Step 3: Install the Ruby Gem Dependencies
To install all the Gem dependencies for the app, we run the bundle command, like this:

```shell
bundle install
```

### Step 4: Install the JavaScript Dependencies
To install all the JavaScript package dependencies for the app, we run the yarn command, like this:

```shell
yarn install
```

### Step 5: Initialize the Database
To initialize the database we run the rails `db:migrate:reset` command, like this:

```shell
rails db:migrate:reset
```

### Step 6: Run the Development Web Server
To start the development webserver that runs the demo app, we run the rails command, like this:

```shell
rails server
```

At this point the base application should be running at [http://localhost:3000](http://localhost:3000)

### Step 7: Generate the UploadedFile Model
To generate the UploadedFile model, run the following:
```shell
rails g model UploadedFile
```

We're basically telling Rails to create a new model named `UploadedFile`.
We are not adding attributes as ActiveStorage automatically handles this once we add the appropriate lines to our model file.

### Step 8: Attaching ActiveStorage to the UploadedFile Model

First, open the file located at `app/models/uploaded_file.rb`. It should look like the following:
```ruby
class UploadedFile < ApplicationRecord

end
```

Between the beginning of class definition (first line) and the `end` statement, add the following:
```ruby
  has_one_attached :file
```

The resulting file should look like the following:
```ruby
class UploadedFile < ApplicationRecord
  has_one_attached :file
end
```