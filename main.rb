require 'yaml'

require_relative 'lib/aws-sdk'
require_relative 'lib/ip'

config = YAML.load(File.read("./config/aws.yaml"))
sg = SecurityGroup.new(
  id: config[:security_group_id],
  region: config[:region_id]
)
original_ip = sg.original_ip(config[:description])
current_ip = Ip.external_address

puts "starts changing original_ip: #{original_ip}\
      description: #{config[:description]} to #{current_ip}"

sg.update_ip(
  to_ip: current_ip,
  port: config[:port],
  description: description[:description]
)

puts "finished."
