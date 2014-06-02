webistrano_slack
================

A Ruby On Rails plugin for [Webistrano](https://github.com/peritor/webistrano) to send deployment updates to [Slack](https://slack.com/) channels. It works better on production mode, because on development mode the models can be reloaded after the plugin, and so the methods are not correctly overwritten.

# Setup
* Setup a new Slack instance and note the subdomain used.
* On the Slack side, add a new "Incoming Webhooks" integration and note the token that Slack generates for you.
* On Webistrano, copy this plugin to vendor/plugins/ and add the following to config/webistrano_config.rb:

  ```ruby
    # Slack integration
    :slack_settings => {
      :webistrano_host => 'http://webistrano.yourdomain.com',
      :token => 'slack_token',
      :instance => 'slack_subdomain',
      :username => 'slack_username',
      :channels => {
        'Webistrano Project Name' => '#slack_channel_name'
      }   
    }
  ```

* Restart the Rails server
