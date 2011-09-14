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

require 'stringio'
require 'net/stun/attributes'

module Net; class STUN
  class Body < Hash
    def self.unpack (bytes)
      bytes = StringIO.new(bytes) unless bytes.is_a?(StringIO)

      new.tap {|o|
        until bytes.eof?
          type, length = bytes.read(4).unpack('nn')
          if Attributes.instance.include?(type)
            o[Attributes::NAME[type]] = Attributes[type].unpack(bytes.read(length))
          else
            bytes.read(length)
          end
        end
      }
    end

    def pack
      map(&:pack).inject(:+) || ''
    end
  end
end; end
