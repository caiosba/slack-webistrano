require 'webistrano_slack'

Deployment.class_eval do

  alias complete_with_error_original! complete_with_error!
  def complete_with_error!
    complete_with_error_original!
    message = "[#{self.stage.project.name}] #{self.user.login} deployed to #{self.stage.name} with errors! <#{self.url}|View log>"
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
  end

  alias complete_successfully_original! complete_successfully!
  def complete_successfully!
    complete_successfully_original!
    message = "[#{self.stage.project.name}] #{self.user.login} deployed to #{self.stage.name} successfully! <#{self.url}|View log>"
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
  end

  def url
    # FIXME: Better to try to call project_stage_deployment_path here
    path = "projects/#{self.stage.project.id}/stages/#{self.stage.id}/deployments/#{self.id}"
    URI.join WebistranoConfig[:slack_settings][:webistrano_host], path
  end
end

Webistrano::Deployer.class_eval do
  alias execute_original! execute!
  def execute!
    message = "[#{deployment.stage.project.name}] #{deployment.user.login} started deploying to #{deployment.stage.name}. <#{deployment.url}|View log>"
    WebistranoSlack.send_to_slack(deployment, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
    execute_original!
  end
end
