require 'net/http'

module WebistranoSlack

  def self.send_to_slack(deployment, settings, success = true)

    token = settings[:token]
    instance = settings[:instance]
    username = settings[:username]
    channel = settings[:channels][deployment.stage.project.name] || '#general'
    slack_url = URI.parse("https://#{instance}.slack.com/services/hooks/incoming-webhook?token=#{token}")

    # FIXME: Better to try to call project_stage_deployment_path here
    deployment_path = "projects/#{deployment.stage.project.id}/stages/#{deployment.stage.id}/deployments/#{deployment.id}"
    deployment_url = URI.join(settings[:webistrano_host], deployment_path)

    msg = "[#{deployment.stage.project.name}] #{deployment.user.login} deployed to #{deployment.stage.name} "
    msg += success ? "successfully" : "with errors"
    msg += "! <#{deployment_url}|View log>"

    params = {
      :text => msg
    }

    params[:username] = username if username
    params[:channel] = channel if channel

    data = { :payload => params.to_json }
    http = Net::HTTP.new(slack_url.host, slack_url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(slack_url.path + '?' + slack_url.query)
    request.set_form_data(data)
    response = http.request(request)
  end

end
