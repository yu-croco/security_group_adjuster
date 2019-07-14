require 'resolv'

module Ip
  @external_address ||=
    Resolv::DNS
      .new(nameserver: 'ns1.google.com')
      .getresources("o-o.myaddr.l.google.com", Resolv::DNS::Resource::IN::TXT)[0].strings[0]

  def self.external_address
    @external_address
  end
end
