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

Before we install the dependencies, we need to add a single dependency to our `Gemfile`. 

We will be utilizing the gem [breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails) for rendering breadcrumbs in our application.

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


#### File Name

The first is a helper function that will return the filename of a file attached to an UploadedFile entity.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def get_filename(uploaded_file)
  uploaded_file.file.blob.filename
end
```

#### Content Type

The second is a helper function that will return the content type (like application/pdf, image/jpeg) for a file attached
to an UploadedFile entity.

Add the following to the `uploaded_files_helper.rb` file in `app/helpers`:

```ruby

def get_content_type(uploaded_file)
  uploaded_file.file.blob.content_type
end
```

#### File Count

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

#### Image

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

#### Including the helper

Right below the class definition, (`class UploadedFilesController < ApplicationController`), add the following:
```ruby
include UploadedFilesHelper
```

This includes the `UploadedFilesHelper` and allows us to call methods from it, which we will use later.

#### Index

The index function needs to have a variable to pass to the view template inorder to show the file list.

To do this, we need to add the following inside the index function:

```ruby
@files = UploadedFile.all
```

This adds a template variable `@files` that is passed and available in the `index.html.erb` layout file.

#### Show

The show function needs to have a variable to pass to the view template that contains information about the selected file.
Additionally, for breadcrumbs, we need to tell the library to add a breadcrumb for the `show` route.

To do this, we need to add the following inside the index function:

```ruby
@file = UploadedFile.find(params[:id])
add_breadcrumb(get_filename(@file))
```

This adds a template variable `@file` that is passed and available in the `show.html.erb` layout file.
The file is retrieved from the URL parameters, specifically the `id` parameter.

#### New

The new function needs to have a variable to pass to the view template which is an empty `UploadedFile` entity.
Additionally, for breadcrumbs, we need to tell the library to add a breadcrumb for the `new` route.

To do this, we need to add the following inside the index function:

```ruby
@file = UploadedFile.new
add_breadcrumb 'Upload File'
```

This adds a template variable `@file` that is passed and available in the `new.html.erb` layout file.
The passed entity is empty, as we will have a form to fill out the information inside.

#### Create

The create function needs to take the parameters sent to it by the form and create a new `UploadedFile` entity with the properties.
Lastly, when the `UploadedFile` entity has been saved in the database, we would like to redirect to the page which shows information about the file.

To do this, we need to add the following inside the create function:

```ruby
file = UploadedFile.create(create_params)
redirect_to uploaded_file_path(file)
```

#### Create Parameters

If you noticed in the last function, create, we accessed a variable defined as `create_params`. Well now we need
to define that variable which actually happens to be a function. The function tells the application to look for an object
in the parameters named `uploaded_file` and only allows us to submit the form if the `uploaded_file` object contains a single object called `file`.

Right before the final `end` append the following:

```ruby
  private

  def create_params
    params.require(:uploaded_file).permit(:file)
  end
```

Please take note of the `private` above the `create_params` definition.

### Step 13: Creating and Editing the View Templates

Inside the `app/views/uploaded_files` directory you should have three files named `index.html.erb`, `new.html.erb`, and `show.html.erb`.
These three files are the main view templates we will modify next.

#### Uploaded File Partial

First we have to make another template (technically a partial in this case) named `_uploaded_file.html.erb`;

Go ahead and do that like so:
```shell
touch app/views/uploaded_files/_uploaded_file.html.erb
```
*(you can also do this in your IDE if you so choose to)*


This has created a 'partial' that Rails will use to render a file, like in a list or something. 

Lets edit the file and add a basic layout like the following:

```html
<%= link_to uploaded_file_path(file), class: "list-group-item d-flex justify-content-between align-items-center" do %>
  <span class="d-block h5 m-0">
      <%= get_filename(file) %>
  </span>
    <span class="d-block text-secondary">
      <%= get_content_type(file) %>
  </span>
<% end %>
```

The block above creates a new `<a>` tag which points to the route that shows information about the current file.
The classes that are added are Bootstrap specific which will come in handy later.


Also notice that we are calling the helper functions we created earlier for the file name and content type.
At this point, we are done editing this partial and we can move on.

#### Index Template
The index template will be a very basic view which will have a list of files. Since we created a partial for an UploadedFile above,
we can use this in our list like so:

```html
<div class="files">
  <%= link_to 'Upload File', new_uploaded_file_path, class: 'btn btn-primary mb-5 mt-2 w-100' %>

  <h5 class="text-secondary text-center font-weight-normal"><%= get_file_count(@files) %></h5>
  <ul class="list-group">
    <% @files.each do |file| %>
      <%= render partial: 'uploaded_file', locals: {file: file} %>
    <% end %>
  </ul>
</div>
```

We're just creating a `<div>` with a class of `files`. Inside the `<div>`, we create a link that takes us to the page where
we can upload a new file. The classes we're assigning to it make it a Bootstrap button with a primary color, and sets the width to 100%.
The `mb-5` and `mt-2` classes create a bit of margin to make the page look a bit nicer.

The `<h5>` tag contains a count of the total files using our helper method we defined earlier. The classes assigned 
center the text, sets the color of the text to a light gray, and make the text less bold.

The `<ul>` tag creates a list that we can fill with our UploadedFile partial we created earlier. Within the block, we see
and example of the Ruby liquid templating logic. This is a for-loop which iterates through the `@files` variable and renders
the UploadedFile partial for that file. The `locals` bit is important as this tells the rendering engine to use that `UploadedFile` entity.
