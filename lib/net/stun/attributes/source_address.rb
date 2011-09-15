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

require 'ipaddr'

module Net; class STUN; class Attributes
  class SourceAddress < IPAddr
    ADDR_FAMILY = {
      1 => Socket::AF_INET,
      2 => Socket::AF_INET6
    }.freeze

    RADDR_FAMILY = {
      Socket::AF_INET   => 1,
      Socket::AF_INET6  => 2
    }.freeze

    attr_accessor :port

    def self.unpack (bytes)
      case bytes.bytesize
      when 8
        family, port, address = bytes.unpack('xCnN')
      when 20
        family, port, a1, a0 = bytes.unpack('xCnQQ')
        address = (a1 << 64) | a0
      else
        return nil
      end

      new(address, ADDR_FAMILY[family], port)
    end

    def initialize (address, family, port)
      super(address, family)
      @port = port
    end

    def pack
      res = if family == Socket::AF_INET6
              a1, a0 = to_i >> 64, to_i & 0x0000000000000000FFFFFFFFFFFFFFFF
              [RADDR_FAMILY[family], port, a1, a0].pack('xCnQQ')
            else
              [RADDR_FAMILY[family], port, to_i].pack('xCnN')
            end

      [0x0004, res.bytesize].pack('nn') + res
    end

    def inspect
      case family
      when Socket::AF_INET
        af = "IPv4"
      when Socket::AF_INET6
        af = "IPv6"
      else
        raise "unsupported address family"
      end
      return sprintf("#<%s: %s:%s/%s:%s>", self.class.name,
		    af, _to_string(@addr), _to_string(@mask_addr), port.to_s)
    end
  end
end; end; end
