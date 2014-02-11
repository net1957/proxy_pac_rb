# encoding: utf-8
module LocalPac
  module SpecHelper
    def app
      LocalPac::FileServer.new
    end
  end
end
