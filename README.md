# Transacted

A library to make writing transactional code easier.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'transacted'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install transacted

## Usage

Require it in your file:

    require 'transacted'

Then you can initialize `Action`s:

    action_options = {
      up: -> {puts "Up !"},
      down: -> {puts "Down !"}
    }
    action = Transacted::Action.new action_options

You can then create a `Transaction` out of `Action`s :

    first_action_options = {
      up: -> {puts "First up !"},
      down: -> {puts "First down !"}
    }
    first_action = Transacted::Action.new first_action_options
    
    second_action_options = {
      up: -> {puts "Second up !"},
      down: -> {puts "Second down !"}
    }
    second_action = Transacted::Action.new second_action_options
    
    transaction = Transacted::Transaction.new [first_action, second_action]

And execute it = 

    transaction_status = transaction.execute
    # First up !
    # Second up !

`transaction_status` would be either
- `:execution_success` : if all the actions are executed successfully
- `:rollback_success` : if an action has failed and the rollback was made successfully
- `:rollback_failure` : if an action has failed during execution, and another failure was encountered during rollback. The transactionality is lost in such cases since the rollback was not successful.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/transacted/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
