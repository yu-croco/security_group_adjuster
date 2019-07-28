require 'aws-sdk'
class AwsSecurityGroup
  attr_reader :sg

  def initialize(id:, region:)
    @sg = Aws::EC2::SecurityGroup.new(id: id, region: region)
  end

  def update_ip(to_ip:, port:, description:)
    from_ip = original_ip(description)
    change_ip(from_ip: from_ip, to_ip: to_ip, port: port, description: description)
  end

  def original_ip(description:)
    ips = sg.ip_permissions.first[:ip_ranges].map do |data|
      data[:cidr_ip] if data[:description] == description
    end

    raise "couldn't find such security_group connected with #{description}" if ips.flatten.compact.empty?

    ips.flatten.compact.first
  end

  private

    def change_ip(from_ip:, to_ip:, port:, description:)
      ingress_permissions = authorize_ingress_permissions(to_ip: to_ip, port: port, description: description)
      sg.authorize_ingress(ip_permissions: ingress_permissions)

      revoked_permissions = revoke_ingress_permissions(from_ip: from_ip, port: port, description: description)
      sg.revoke_ingress(ip_permissions: revoked_permissions)
    end

    def authorize_ingress_permissions(to_ip:, port:, description:)
      {
        ip_protocol: 'tcp',
        from_port: port,
        ip_ranges: [
          {
            cidr_ip: to_ip,
            description: description,
          },
        ],
        to_port: port
      }
    end

    def revoke_ingress_permissions(from_ip:, port:, description:)
      {
        ip_protocol: 'tcp',
        from_port: port,
        ip_ranges: [
          {
            cidr_ip: from_ip,
          },
        ],
        to_port: port
      }
    end
end
