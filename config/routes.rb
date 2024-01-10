Rails.application.routes.draw do
  resources :users
  post 'auth/login', to: 'authentication#login'
  post '/forgot_password', to: 'passwords#forgot_password'
  post '/resend_otp', to: 'passwords#resend_otp'
  post '/verify_otp', to: 'passwords#verify_otp'
  post '/reset_password', to: 'passwords#reset_password'
  resources :experts 
  get '/experts/:id/courses', to: 'experts#courses', as: 'expert_courses'
  resources :courses
 resources :orders
 post '/courses/:id/purchase', to: 'courses#purchase_course'
end
