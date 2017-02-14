class StyleguidesController < ApplicationController
  include Styledown::Rails::Controller

  # Where your styleguides are stored
  styledown.root = 'docs/styleguides'

  # Partial to be added before </head>
  styledown.append_template :head, 'styleguides/head'

  # Languages in examples to be using Rails template engines
  styledown.use_template_engine :<%= options[:template_engine] %>
end
