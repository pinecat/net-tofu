# frozen_string_literal: true

# MIT License
#
# Copyright (c) 2020 Étienne Deparis
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require "uri"

module URI # :nodoc:
  #
  # The syntax of Gemini URIs is defined in the Gemini specification,
  # section 1.2.
  #
  # @see https://gemini.circumlunar.space/docs/specification.html
  #
  class Gemini < HTTP
    # A Default port of 1965 for URI::Gemini.
    DEFAULT_PORT = 1965

    # An Array of the available components for URI::Gemini.
    COMPONENT = %i[scheme host port
                   path query fragment].freeze
  end

  if respond_to? :register_scheme
    # Introduced somewhere in ruby 3.0.x
    register_scheme "GEMINI", Gemini
  else
    @@schemes["GEMINI"] = Gemini
  end
end
