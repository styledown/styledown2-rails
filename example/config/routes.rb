Rails.application.routes.draw do
  resource 'styleguides', only: [:show] do
    get '*page', action: :show, as: :page
  end

  root to: redirect('/styleguides')
end
