class PagesController < ApplicationController
  include PageBeforeActions
  include PagePostActions

  layout false, only: :sitemap

  before_action :set_page, :set_site, :set_metadata, :ensure_page_available, only: [:show, :post]

  def show
    send(@page.before_action.to_sym) if @page.before_action.present? && respond_to?(@page.before_action.to_sym)

    render partial
  end

  def post
    send(@page.post_action.to_sym) if @page.post_action.present? && respond_to?(@page.post_action.to_sym)
  end

  def sitemap
    headers["Content-Type"] = "application/xml"
    respond_to { |f| f.xml { @pages = Content::Page.all } }
  end

  protected

  def set_page
    @page = Content::Page.includes(:fields, :page_blueprint).find_by(id: params[:page_id])
  end

  def set_site
    @site = params[:site].present? ? Site.find_by(id: params[:site]) : Site.find_by(default: true)
  end

  def set_metadata
    @metadata = {
      title: @page.title,
      description: @page.meta_description,
      keywords: @page.meta_keywords
    }
  end

  def ensure_page_available
    raise ActionController::RoutingError, "Page Not Found" unless page_available_for_site?
  end

  def page_available_for_site?
    @page.sites.none? || @page.sites.include?(@site)
  end

  # Partial defaults to "_body"
  # If a '/' is found in the blueprint template, then the last section is used
  # So "orphans/raise" will use the `_raise.html.erb` partial from with the `orphans` folder.
  def partial
    segments = @page.template.split("/").map!(&:underscore)

    # If we have multiple segments & they target an existing page partial
    if segments.count > 1 && lookup_context.exists?(segments.join("/"), ["pages"], true)
      partial = segments.pop

      return partial_path(segments.join("/"), partial)
    end

    partial_path(segments.join("/"))
  end

  def partial_path(template, partial = "body")
    format("pages/%s/%s", template, "_#{partial}")
  end
end
