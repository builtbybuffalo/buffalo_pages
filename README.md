# Install

```
gem 'buffalo_pages', github: 'builtbybuffalo/buffalo_pages'
```

Once installed, you'll need to grab migrations with:

```
rake buffalo_pages:install
rake db:migrate
```

## Routes

```
    namespace :content do
      get "page_blueprints/export(/:page_blueprint_id)", to: "page_blueprints#export", as: :page_blueprints_export
      get "page_blueprints/import", to: "page_blueprints#import", as: :page_blueprints_import
      post "page_blueprints/process", to: "page_blueprints#process_import"

      resources :page_blueprints, except: [:show] do
        resources :field_blueprints
      end

      resources :pages do
        resources :fields
      end

      resources :image_uploads, only: [:create]
    end

    resources :menus do
      resources :menu_items
    end

    resources :sites do
      collection do
        post :reset
      end

      member do
        post :set
      end
    end
```

This is only tested in the `admin` namespace, so you may experience errors using this anywhere else.

## Access Control

There is no access control provided here. You'll need to do that yourself. Don't forget!
