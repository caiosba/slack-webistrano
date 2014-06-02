require 'webistrano_slack'

Deployment.class_eval do

  alias complete_with_error_original! complete_with_error!
  def complete_with_error!
    complete_with_error_original!
    message = "[#{self.stage.project.name}] #{self.user.login} did #{self.task} to #{self.stage.name} *with errors*! (ID #{self.id}) <#{self.url}|View log>"
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
  end

  alias complete_successfully_original! complete_successfully!
  def complete_successfully!
    complete_successfully_original!
    message = "[#{self.stage.project.name}] #{self.user.login} did #{self.task} to #{self.stage.name} *successfully*! (ID #{self.id}) <#{self.url}|View log>"
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
  end

  alias complete_canceled_original! complete_canceled!
  def complete_canceled!
    message = "[#{self.stage.project.name}] #{self.user.login} *canceled* #{self.task} to #{self.stage.name}! (ID #{self.id}) <#{self.url}|View log>"
    WebistranoSlack.send_to_slack(self, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
    complete_canceled_original!
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
    message = "[#{deployment.stage.project.name}] #{deployment.user.login} *started* to #{deployment.task} to #{deployment.stage.name} (ID #{deployment.id})#{deployment.description.blank? ? '' : ': _"' + deployment.description + '"_'}. <#{deployment.url}|View log>"
    WebistranoSlack.send_to_slack(deployment, WebistranoConfig[:slack_settings], message) unless WebistranoConfig[:slack_settings].nil?
    execute_original!
  end
end
