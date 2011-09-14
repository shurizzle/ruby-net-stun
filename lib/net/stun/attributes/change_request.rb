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

module Net; class STUN; class Attributes
  class ChangeRequest < Struct.new(:change_ip, :change_port)
    def self.unpack (bytes)
      byte = bytes.unpack('N') >> 1
      new(!(byte & 0x00000002).zero?, !(byte & 0x00000001).zero?)
    end

    def pack
      res = [(change_ip ? 4 : 0) + (change_port ? 2 : 0)].pack('N')
      [0x0003, res.bytesize].pack('nn') + res
    end
  end
end; end; end
