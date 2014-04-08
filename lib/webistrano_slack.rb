require 'net/http'

module WebistranoSlack

  def self.send_to_slack(deployment, settings, message)

    token = settings[:token]
    instance = settings[:instance]
    username = settings[:username]
    channel = settings[:channels][deployment.stage.project.name] || '#general'
    slack_url = URI.parse("https://#{instance}.slack.com/services/hooks/incoming-webhook?token=#{token}")

    params = {
      :text => message
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
