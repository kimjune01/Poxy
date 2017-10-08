class StaticController < ApplicationController

  def show
    render file: "public/eula.html" status: :ok
  end
end