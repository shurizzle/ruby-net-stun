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
  class AlternateServer < Struct.new(:port, :address)
    ADDR_FAMILY = {
      1 => Socket::AF_INET,
      2 => Socket::AF_INET6
    }.freeze

    def self.unpack (bytes)
      family, port, address = bytes.unpack('xCnN')
      new(port, IPAddr.new(address, ADDR_FAMILY[family]).to_s)
    end

    def pack
      res = [family, port, address].pack('xCnN')
      [0x8023, res.bytesize].pack('nn') + res
    end
  end
end; end; end
