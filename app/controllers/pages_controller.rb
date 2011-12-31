# Kebab 2.0 - Server Ror
#
# Author::    Onur Özgür ÖZKAN <onur.ozgur.ozkan@lab2023.com>
# Copyright:: Copyright (c) 2011 lab2023 - internet technologies
# License::   Distributes under MIT

# Pages Controller
class PagesController < ApplicationController
  skip_before_filter :authenticate, only: [:login]
  skip_before_filter :authorize

  # GET/pages/desktop
  def desktop
  end

  # GET/pages/login
  def login
  end
end
