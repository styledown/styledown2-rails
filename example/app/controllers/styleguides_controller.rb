class StyleguidesController < ApplicationController
  include Styledown::Rails::Controller

  styledown.root = 'docs/styleguides'
  styledown.append_template :head, 'styleguides/head'

  def show
    styledown.show self
  end
end
