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
      # If a project is not present on the hash "channels" below, the notifications will go to the default channel
      :default_channel => '#slack_channel_name',
      :channels => {
        'Webistrano Project Name' => '#slack_channel_name',
        # Mapping a project to an empty string will disable notifications for this project 
        'Project that you do not want notifications' => ''
      }   
    }
  ```

* Restart the Rails server
