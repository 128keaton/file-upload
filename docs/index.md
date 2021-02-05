# ActiveStorage File Upload in Rails

## Prerequisites

### *Development Environment Setup*

Please make sure you have setup your development environment
following [these](https://human-se.github.io/rails-demos-n-deets-2021/demos/development-environment/) instructions.

As a result, you should have the following installed on your development machine:

* Ruby 2.7.2
    * Rails 6+
* Postgres
* Yarn (or npm)

If the above is all installed and working properly, you are ready to move to the next step.

## Adding File Uploads

### Step 1: Clone the GitHub Repo

First, clone the base repository located like this:

```shell
git clone https://github.com/128keaton/file-upload
```

### Step 2: Switch to the `main` Branch

The main branch contains the base application to begin adding file uploads. This branch contains the migrations
necessary for ActiveStorage

```shell
git switch main
```

### Step 3: Install the Ruby Gem Dependencies

Before we install the dependencies, we need to add a single dependency to our `Gemfile`. We will be utilizing the gem "
[breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails)" for rendering breadcrumbs in our application.

Add the following to the `Gemfile` located at the root of the project:

```ruby
gem "breadcrumbs_on_rails"
```

Then, we can install all the Gem dependencies for the app. We should run the bundle command, like this:

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

We're basically telling Rails to create a new model named `UploadedFile`. We are not adding attributes as ActiveStorage
automatically handles this once we add the appropriate lines to our model file.

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

### Step 9: Creating the UploadedFiles Controller

To generate the UploadedFiles controller, run the following:

```shell
rails g controller uploaded_files new show index create
```

This will create a file named `uploaded_files_controller.rb` in `app/controllers` as well as three template files
in `app/views/uploaded_files`. Additionally, the helper (UploadedFilesHelper) will be created in `app/helpers`.

### Step 10: Adding Helper Methods

Within Rails, its nice to use helpers in order to simplify some layout code. Lets add a few things to the
UploadedFilesHelper.

The first is a helper function that will return the filename of a file attached to an UploadedFile entity.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def get_filename(uploaded_file)
  uploaded_file.file.blob.filename
end
```

The second is a helper function that will return the content type (like application/pdf, image/jpeg) for a file attached
to an UploadedFile entity.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def get_content_type(uploaded_file)
  uploaded_file.file.blob.content_type
end
```

The third is a helper function that simplifies the logic needed in the layout file. It will return a string like "1
file" or "2 files", depending on how many UploadedFile entities exist in the database.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def get_file_count(uploaded_files)
  if uploaded_files.count.equal? 1
    '1 file'
  else
    "#{uploaded_files.count} files"
  end
end
```

The fourth is a helper function that checks if a file's content type is of an image. You will see how we use this later.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def image?(uploaded_file)
  content_type = get_content_type(uploaded_file)

  content_type.to_s.split('/').first == 'image'
end
```

The fifth and final is a helper function that checks if a file's content type is that of a PDF.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def pdf?(uploaded_file)
  get_content_type(uploaded_file) == 'application/pdf'
end
```

When all is said and done, the helper file should look
like [this](https://github.com/128keaton/file-upload/blob/demo/app/helpers/uploaded_files_helper.rb).

### Step 11: Adding Routes

This application is very simple and as such, we can utilize the `resources` helper in our `app/config/routes.rb` file.

All the routes in this very simple application can be added with two lines:

```ruby
resources :uploaded_files

root 'uploaded_files#index'
```

The resulting `routes.rb` file should look
like [this](https://github.com/128keaton/file-upload/blob/demo/app/helpers/uploaded_files_helper.rb).

### Step 12: Adding Controller Methods

Your controller file should look like this to start with:

```ruby

class UploadedFilesController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end
end

```

The index function needs to have a variable to pass to the view template inorder to show the file list.

To do this, we need to add the following inside the index function:

```ruby
@files = UploadedFile.all
```

This adds a template variable `@files` that is passed and available in the `index.html.erb` layout file.