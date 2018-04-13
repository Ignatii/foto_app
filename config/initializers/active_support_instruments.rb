logger = Logger.new(File.join(Rails.root, 'log', "ShowUsersInsta.log"))
ActiveSupport::Notifications.subscribe(%r/ShowUsersInsta.\.*/) do |name, start, ending, transaction_id, payload|
  method = name.split(?.).last
  duration = (1000.0 * (ending - start))
  message = if payload[:exception].present?
    payload[:exception].join(' ')
  else
    payload[:desc].to_s
  end
  logger.info("Benchmark:%s: %.0fms - %s" % method, duration, message)
end
