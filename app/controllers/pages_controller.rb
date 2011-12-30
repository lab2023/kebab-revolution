class PagesController < ApplicationController
  skip_before_filter :authenticate, only: [:login]

  def desktop
  end

  def login
  end
end
