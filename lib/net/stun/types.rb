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
require 'net/stun/body'
require 'net/stun/header'
require 'net/stun/attributes'

module Net; class STUN
  class Types < Hash
    class Type
      def self.code (n)
        self.class_eval {
          define_method(:no) {
            n
          }
        }
      end

      def self.attributes (*attrs)
        attrs = attrs.select {|x| Net::STUN::Attributes::NAME.values.include?(x) }.map {|x| x.is_a?(Symbol) ? x : x.to_s.to_sym }

        self.class_eval { define_method(:attributes) { attrs } }

        attrs.each {|attrib|
          self.class_eval {
            define_method(attrib) { body[attrib] }

            define_method("#{attrib}=") {|args|
              body[attrib] = Net::STUN::Attributes::CLASS[attrib].send((args.is_a?(Array) ? :new : :unpack), *args)
            }
          }
        }
      end

      def initialize (*args)
        args.select {|x| x.is_a?(Hash) }.inject(:merge).tap {|a|
          a.each {|name, value|
            send("#{name}=", value) if respond_to?("#{name}=")
          } if a
        }
        @body = Body.new
      end

      def pack
        (@body.keys - attributes).each {|key|
          body.delete(key)
        }

        b = body.pack
        Header.new(no, b.bytesize).pack + b
      end

      protected
      def body
        @body
      end
    end

    include Singleton

    def self.[] (type)
      instance[type]
    end
  end
end; end

%w[binding_request binding_response binding_error_response shared_secret_request
  shared_secret_response shared_secret_error_response].each {|type|
  require "net/stun/types/#{type}"
}

Net::STUN::Types.instance[0x0001] = Net::STUN::Types::BindingRequest
Net::STUN::Types.instance[0x0101] = Net::STUN::Types::BindingResponse
Net::STUN::Types.instance[0x0111] = Net::STUN::Types::BindingErrorResponse
Net::STUN::Types.instance[0x0002] = Net::STUN::Types::SharedSecretRequest
Net::STUN::Types.instance[0x0102] = Net::STUN::Types::SharedSecretResponse
Net::STUN::Types.instance[0x0112] = Net::STUN::Types::SharedSecretErrorResponse
Net::STUN::Types.instance.freeze
