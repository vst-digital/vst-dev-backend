Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  scope path: 'api' do
    root "users#sessions"
    resources :organizations
    resources :project_user_memo_replies
    resources :project_user_memos do 
      collection do
        get :get_recieved_memo
        get :get_sent_memo
      end
    end
    resources :groups do 
      post "members_add"
      post "members_remove"
    end 
    resources :projects do 
      post "assign_group"
    end
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
        get "get_group_member"
      end
    end
  end
end
