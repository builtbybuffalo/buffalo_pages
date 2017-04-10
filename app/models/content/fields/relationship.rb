=begin
# Example Config
# The example below will present a drop down on the page showing the categories
# which match the "top_level" scope.
# `news` and `images` will be included in the query to avoid n+1 queries
{
    "model": "NewsCategory",
    "selectable": {
      "scopes": ["top_level"],
      "order": "title",
      "sort": "asc"
    },
    "includes": ["news", "image"],
    "help_text": "Choose an News Category to show here",
    "name_attribute": "title"
}

# Example Markup
<p><%= @page.faq.question %></p>
<p><%== @page.faq.answer %></p>

=========================
# Example Config
{
    "model": "Gallery",
    "scopes": ["by_created"],
    "includes": ["gallery_items", "image"],
    "limit": "4"
}

# Example Markup
<div class="row">
  <% @page.faqs.each do |faq| %>
    <div class="col-sm-6 col-md-4">
      <p><%= faq.question %></p>
      <p><%== faq.answer %></p>
    </div>
  <% end %>
</div>

=========================
# Example Config
#
# Using a where statement to only get pages with projects in the slug field
{
    "model": "Content::Page",
    "where": "slug LIKE '%projects%'",
    "includes": ["fields"]
}

=========================
# Example Config
{
  "model": "News"
}

In the page before_action:

```
@q = @page.news.chronological.published.ransack({})
@collection = @q.result(distinct: true).page(params[:page] || 1).per(10)
```

In the view:
```
<ul>
  <% @collection.each do |news| %>
    <li><%= news.title %></li>
  <% end %>
</ul>
<%= paginate @collection %>
```
=end

module Content
  module Fields
    class Relationship < Field
      SELECTABLE_OPTIONS = {
        order: :id,
        sort: :asc,
        scopes: []
      }.with_indifferent_access.freeze

      has_one :field, as: :thingable

      delegate :each, :each_with_index, :to_s, to: :relation

      def self.selectable_collection_from_config(config)
        raise "A model is required within the config" unless config[:model].present?

        relationship = config[:model].constantize

        return relationship.all unless config[:selectable].present?

        options = SELECTABLE_OPTIONS.merge(config[:selectable])

        options[:scopes].each do |scope|
          relationship = relationship.send(scope)
        end

        relationship.order("#{options[:order]}": options[:sort])
      end

      def method_missing(method_name, *args)
        relation.send(method_name) || super
      end

      def respond_to_missing?(method_name, include_private = false)
        relation.send(method_name).present?
      rescue
        super
      end

      protected

      def relation
        return thingable if thingable.present?

        build_relationship
      end

      # rubocop:disable Metrics/AbcSize
      def build_relationship
        relationship = thingable_type.constantize

        relationship = if config[:limit].present?
                         relationship.limit(config[:limit])
                       else
                         relationship.all
                       end

        relationship = relationship.where(config[:where].to_s) if config[:where].present?
        relationship = relationship.includes(config[:includes].to_a) if config[:includes].present?

        config[:scope].each { |scope| relationship = relationship.send(scope) } if config[:scope].present?

        relationship
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
