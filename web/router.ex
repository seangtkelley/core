defmodule Core.Router do
  use Core.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Core do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/platform", PageController, :platform
    # get "/candidates", PageController, :candidates
    # get "/candidates/:candidate", PageController, :candidate

    get "/petition/:petition", PetitionController, :get
    post "/petition/:petition", PetitionController, :post

    get "/form/:form", FormController, :get
    get "/info/:info", InfoController, :get

    get "/act", ActController, :get
    get "/act/:candidate", ActController, :get_candidate
    get "/act/call/:candidate", ActController, :get_call_candidate
    get "/act/calling-html/:candidate", ActController, :candidate_calling_html

    get "/call", VoxController, :get
    get "/call/logins", VoxController, :get_logins
    post "/call", VoxController, :post

    get "/unsubscribe", SubscriptionController, :unsubscribe_get
    post "/unsubscribe", SubscriptionController, :unsubscribe_post
    get "/unsubscribe/:candidate", SubscriptionController, :unsubscribe_candidate_get
    post "/unsubscribe/:candidate", SubscriptionController, :unsubscribe_candidate_post

    get "/entry", EntryController, :get
  end


  scope "/api", Core do
    get "/update/cosmic", UpdateController, :cosmic
    post "/tf-submit/submit-event", TypeformController, :submit_event
  end
end
