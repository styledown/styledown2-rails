class StyleguidesController < ApplicationController
  include Styledown::Rails::Controller

  styledown.root = 'docs/styleguides'

  def show
    styledown.show self
  end
end
