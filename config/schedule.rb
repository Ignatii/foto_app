# every :hour do
every :minute do
  rake "shit_image:call_shitty", environment: 'development'
end