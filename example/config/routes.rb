Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource 'styleguides', only: [:show] do
    get '*page', action: :show
  end
end
