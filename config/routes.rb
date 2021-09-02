Rails.application.routes.draw do
  root to: "import#new"

  resource :import, only: %w(new show create), controller: "import"
end
