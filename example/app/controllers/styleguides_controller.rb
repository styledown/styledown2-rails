class StyleguidesController < ApplicationController
  include Styledown::Rails::Controller

  styledown.root = 'docs/styleguides'
  styledown.append_template :head, 'styleguides/head'
  styledown.use_template_engine :erb, :haml
end
