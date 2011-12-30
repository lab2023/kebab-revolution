class PagesController < ApplicationController
  skip_before_filter :authenticate, only: [:login]
  skip_before_filter :authorize

  def desktop
  end

  def login
  end
end
