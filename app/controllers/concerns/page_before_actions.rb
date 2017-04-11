# Example
# The following method needs to be aded to the page blueprints before_action field.
#
# def build_galleries
#   @q = Gallery.published.with_associations.ransack(params[:q] || {})
#   @q.sorts = "title #{(params[:q].try(:[], :dir) || 'asc')}" if @q.sorts.empty?
#   @galleries = @q.result(distinct: true).page(params[:page] || 1).per(12)
# end

module PageBeforeActions
  extend ActiveSupport::Concern
end
