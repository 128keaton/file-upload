Rails.application.routes.draw do
  resources :uploaded_files

  root 'uploaded_files#index'
end
