require 'webistrano_slack'

Deployment.class_eval do
  alias complete_with_error_original! complete_with_error!
  def complete_with_error!
    complete_with_error_original!
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], false) unless WebistranoConfig[:slack_settings].nil?
  end

  alias complete_successfully_original! complete_successfully!
  def complete_successfully!
    complete_successfully_original!
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], true) unless WebistranoConfig[:slack_settings].nil?
  end
end
