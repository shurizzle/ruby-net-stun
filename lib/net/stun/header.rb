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

module Net; class STUN
  class Header
    attr_accessor :type, :id, :length

    def initialize (type=nil, length=nil, id=nil)
      @type = type
      @length = length || 0
      @id = id || Kernel.rand(2 ** 96)
    end

    alias size length

    def pack
      [type, length, cookie, id >> 32, id & 0x000000000000000011111111].pack('nnNQN')
    end

    def cookie
      0x2112A442
    end

    def inspect
      "#<#{self.class}:#{"%#.14x" % [__id__]} type=#{type.inspect}, length=#{length}, cookie=#{"%#x" % cookie}, id=#{id}>"
    end


    def self.unpack (bytes)
      raise ArgumentError unless bytes.is_a?(String) and bytes.bytesize == 20
      type, len, id1, id0 = bytes.unpack('nnxxxxQN')
      new(type & 0x3FFF, len, (id1 << 32) | id0)
    end

    def self.read (io)
      raise ArgumentError unless io.is_a?(IO)
      unpack(io.sysread(20))
    end
  end
end; end
