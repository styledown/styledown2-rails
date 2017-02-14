# Manual install

If you prefer not to use the `styledown:install` generator, you can install Styledown manually by making the files yourself.

0. **Controller** — Make a controller to host your styleguides.

  <details>
  <summary>_app/controllers/styleguides\_controller.rb_</summary>

  ```rb
  class StyleguidesController < ApplicationController
    include Styledown::Rails::Controller

    styledown.root = 'docs/styleguides'
    styledown.append_template :head, 'styleguides/head'
    styledown.use_template_engine :erb, :haml
  end
  ```
  </details>

0. **Routes** — Add routes for your new controller.

  <details>
  <summary>_config/routes.rb_</summary>

  ```rb
  resource 'styleguides', only: [:show] do
    get '*page', action: :show, as: :page
  end
  ```
  </details>

0. **View (optional)** — Create the `styleguides/head` partial. This will be injected into the `<head>` section. Optional: you can skip this by changing the controller's `styleguide.append_template` options to use a different partial instead.

  <details>
  <summary>_app/views/styleguides/\_head.html.erb_</summary>

  ```erb
  <%= stylesheet_link_tag 'application' %>
  <%= javascript_include_tag 'application' %>
  ```
  </details>

0. **Styleguides** — Make your first styleguide in `docs/styleguides`.
  <details>
  <summary>_docs/styleguides/index.md_</summary>

			# Styleguides

			These are example styleguides.

			### buttons
			These are buttons. And since we defined :haml in `use_template_engine`,
			these haml examples will be rendered within Rails.

			```example.haml
			%a.btn.btn-default Click me
			```

  </details>

0. **Try it out** — you should now have <http://localhost:3000/styleguides>. Enjoy!
