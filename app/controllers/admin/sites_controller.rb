module Admin
  class SitesController < Admin::ResourceController
    def set
      cookies.signed[:is_impersonating_site] = true
      cookies.signed[:site_id] = @object.id

      redirect_to root_path, flash: { success: I18n.t(:site_set, site: @object.name) }
    end

    def reset
      cookies.signed[:site_id] = nil
      cookies.signed[:current_currency] = nil
      cookies.signed[:is_impersonating_site] = false

      redirect_to :back, flash: { info: I18n.t(:site_reset) }
    end

    protected

    def not_loadable_actions
      [:reset]
    end
  end
end
