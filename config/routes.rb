Rails.application.routes.draw do
  resources :user_memo_templates
  resources :groups do 
    post "members_add"
    post "members_remove"
  end 

  resources :projects do 
    post "assign_group"
  end
  resources :organizations
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

  resources :members do 
    member do
    end
    collection do
      post "invite"
      post "accept_invitation"
      get "invited_contacts"
    end
  end
  root "users#sessions"
end
