# Capybara::AsyncRunner

[![Build Status](https://travis-ci.org/iliabylich/capybara-async-runner.svg?branch=master)](https://travis-ci.org/iliabylich/capybara-async-runner)
[![Code Climate](https://codeclimate.com/github/iliabylich/capybara-async-runner/badges/gpa.svg)](https://codeclimate.com/github/iliabylich/capybara-async-runner)
[![Inline docs](http://inch-ci.org/github/iliabylich/capybara-async-runner.svg?branch=master)](http://inch-ci.org/github/iliabylich/capybara-async-runner)

This is a ruby gem for running asynchronous JavaScript code synchronously with Capybara.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-async_runner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-async_runner

## Usage

Read [this](http://ilyabylich.svbtle.com/capybara-and-asynchronous-stuff) blog post first.
Then check out `examples` dir.

## How to use

+ Setup a directory with command templates

``` ruby
Capybara::AsyncRunner.setup do |config|
  config.commands_directory = Rails.root.join('directory/with/templates')
end
```

+ Create a command

``` ruby
class MyCommand < Capybara::AsyncRunner::Command
  # specify the name
  self.command_name = :my_command
  # specify a path to template
  self.template = 'template_name'
  # specify a response
  response :done
end
```

+ Create a template file

``` javascript
// directory/with/templates/template_name.js.erb
yourCode(function(data) {
  <%= done(js[:data]) %>
})
```

+ Call the command

``` ruby
Capybara::AsyncRunner.run(:my_command)
# => data from your script
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/capybara-async_runner/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
