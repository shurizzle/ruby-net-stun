#--
# Copyleft shura. [ shura1991@gmail.com ]
#
# This file is part of net-stun.
#
# net-stun is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# net-stun is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with net-stun. If not, see <http://www.gnu.org/licenses/>.
#++

require 'singleton'

module Net; class STUN
  class Attributes < Hash
    NAME = {
      0x0001  => :mapped_address,
      0x0002  => :response_address,
      0x0003  => :change_request,
      0x0004  => :source_address,
      0x0005  => :changed_address,
      0x0006  => :username,
      0x0007  => :password,
      0x0008  => :message_integrity,
      0x0009  => :error_code,
      0x000a  => :unknown_attributes,
      0x000b  => :reflected_from,
      0x0020  => :xor_mapped_address,
      0x8022  => :software,
      0x8023  => :alternate_server
    }.freeze

    CODE = Hash[NAME.map {|x,y|[y,x]}].freeze

    CLASS = Hash.new {|hash, x| Net::STUN::Attributes[CODE[x]] }.freeze

    include Singleton

    def self.[] (type)
      instance[type]
    end
  end
end; end

Net::STUN::Attributes::NAME.values.each {|attr|
  require "net/stun/attributes/#{attr}"
}

Net::STUN::Attributes.instance[0x0001] = Net::STUN::Attributes::MappedAddress
Net::STUN::Attributes.instance[0x0002] = Net::STUN::Attributes::ResponseAddress
Net::STUN::Attributes.instance[0x0003] = Net::STUN::Attributes::ChangeRequest
Net::STUN::Attributes.instance[0x0004] = Net::STUN::Attributes::SourceAddress
Net::STUN::Attributes.instance[0x0005] = Net::STUN::Attributes::ChangedAddress
Net::STUN::Attributes.instance[0x0006] = Net::STUN::Attributes::Username
Net::STUN::Attributes.instance[0x0007] = Net::STUN::Attributes::Password
Net::STUN::Attributes.instance[0x0008] = Net::STUN::Attributes::MessageIntegrity
Net::STUN::Attributes.instance[0x0009] = Net::STUN::Attributes::ErrorCode
Net::STUN::Attributes.instance[0x000a] = Net::STUN::Attributes::UnknownAttributes
Net::STUN::Attributes.instance[0x000b] = Net::STUN::Attributes::ReflectedFrom
Net::STUN::Attributes.instance[0x0020] = Net::STUN::Attributes::XORMappedAddress
Net::STUN::Attributes.instance[0x8022] = Net::STUN::Attributes::Software
Net::STUN::Attributes.instance[0x8023] = Net::STUN::Attributes::AlternateServer
Net::STUN::Attributes.instance.freeze
