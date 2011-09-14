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
  class ErrorCode < Struct.new(:c_class, :number, :reason)
    def self.unpack (bytes)
      klass, number, reason = bytes.unpack('xxCCA*')
      reason.force_encoding('UTF-8')
      klass &= 0x07
      new(klass, number, reason)
    end

    def pack
      res = [c_class, number, reason].pack('xxCCA*')
      [0x0009, res.bytesize].pack('nn') + res
    end
  end
end; end; end
