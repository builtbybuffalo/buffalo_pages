class ContentPageRouter
  def self.load
    Rails.application.routes.draw do
      # We made up a Verb.
      # Without this generic route, which specifically impliments a new HTTP verb,
      # `url_for` (which is used by Kaminari) cannot properly calculate the required
      # routes that are needed for http links pointing at pages. Instead of finding the
      # right route, it picks the first page it comes to.
      match "/:slug", to: "pages#show", via: :PAGE

      Content::Page.published.find_each do |page|
        if page.sites.any?
          page.sites.each do |site|
            defaults = { slug: page.slug, site: site.id, locale: site.locale }
            site_slugs = [site.name.parameterize]
            site_slugs.push nil if site.default?

            site_slugs.each do |slug|
              slug = "/#{slug.present? ? slug + "/" : ""}#{page.slug}"

              get slug, to: "pages#show", defaults: defaults, as: "page_#{slug.parameterize.underscore}"
              post slug, to: "pages#post", defaults: defaults, as: "post_#{slug.parameterize.underscore}" if page.accepts_post
            end
          end
        else
          defaults = { slug: page.slug }
          slug = page.slug

          get slug, to: "pages#show", defaults: defaults, as: "page_#{slug}"
          post slug, to: "pages#post", defaults: defaults, as: "post_#{slug}" if page.accepts_post

        end
      end

      # A special route for the pages sitemap, which should be added to the regular sitemap.xml as a linked sitemap
      get "page-sitemap", to: "pages#sitemap", defaults: { formats: :xml }
    end
  end

  def self.redraw
    Rails.application.routes_reloader.reload!
  end
end
