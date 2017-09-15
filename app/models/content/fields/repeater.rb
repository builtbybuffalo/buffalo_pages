## Example config_json for creating repeaters:
=begin
  {
    "limit": 4,
    "repeaters": [
       {
           "variable_name": "img",
           "type": "Content::Fields::Image",
           "json_config": {
               "help_text": "An image to enhance the FAQ",
               "styles": {
                   "large": "1000x700>",
                   "medium": "500x350>",
                   "thumb": "200x200!"
               }
           }
       },
       {
           "variable_name": "title",
           "type": "Content::Fields::Text",
           "json_config": {
               "help_text": "The FAQ title text"
           }
       },
       {
         "variable_name": "faq",
         "type": "Content::Fields::Relationship",
         "json_config": {
             "model": "Faq",
             "scope": ["by_created"],
             "selectable": true,
             "help_text": "Choose an FAQ to show",
             "name_attribute": "question"
          }
       }
     ],
     "help_text": "The Faqs page"
  }

# Example markup
<div class="row">
  <% @page.faqs.each do |faq| %>
    <div class="col-sm-6 col-md-4">
      <div class="thumbnail">
        <img src="<%= faq.img.url(:medium) %>">
        <div class="caption">
          <h3><%= faq.title %></h3>
          <p><%= faq.img.name %></p>
          <p><%= faq.img.caption %></p>
        </div>
      </div>
    </div>
    <p><%= faq.faq.question %></p>
    <p><%== faq.faq.answer %></p>
  <% end %>
</div>
=end
module Content
  module Fields
    class Repeater < Field
      has_many :repeater_groups, -> { order(position: :asc) }, dependent: :destroy
      accepts_nested_attributes_for :repeater_groups, allow_destroy: true

      delegate :each, :each_with_index, :map, :count, :any?, :size, :length, :limit, :first, :offset,
        to: :repeater_groups

      # This method is run when a new repeater group is added to a page as the json_config
      # is updated for the new elements
      def reconfigure(_ = false)
        return unless json_config_changed?

        transfer_or_destroy_existing_fields
        update_fields
      end

      def fields
        repeater_groups.map(&:fields).flatten
      end

      def to_s
        raise "This class must be iterated over and not output directly to the page"
      end

      protected

      # Find any fields that have been removed from the config and remove them.
      # If the field type changes and the variable name remains the same, the field is still deleted
      # rubocop:disable Metrics/AbcSize
      def transfer_or_destroy_existing_fields
        now = config[:repeaters] - config_was[:repeaters]
        was = config_was[:repeaters] - config[:repeaters]

        return unless (now + was).any?

        was.each do |field|
          if (updatable = now.find { |f| f[:variable_name] == field[:variable_name] }).blank?
            delete_fields_by_variable_name(field[:variable_name])

            next
          end

          # If the field types have not been changed we can move on
          next if field[:type] == updatable[:type]

          # We know the field type has been changed, but both must be transferable types or the field is deleted
          unless transferable(field[:type]) && transferable(updatable[:type])
            delete_fields_by_variable_name(field[:variable_name])
          end
        end
      end
      # rubocop:enable Metrics/AbcSize

      # Push any changes to the config to each field and cascade the reconfigure.
      # We do not create fields here as that is done in the forms nested fields when the page is saved.
      def update_fields
        now = config[:repeaters] - config_was[:repeaters]

        now.reject { |f| deleted_variables.include? f[:variable_name] }.each do |repeater_field|
          fields_by_variable_name(repeater_field[:variable_name]).each do |field|
            field.update_attributes(build_field_attributes(repeater_field))
            field.reconfigure(true)
          end
        end
      end

      def fields_by_variable_name(variable_name)
        repeater_groups.map(&:fields).flatten.select { |f| f.variable_name == variable_name }
      end

      def delete_fields_by_variable_name(variable_name)
        deleted_variables << variable_name

        fields_by_variable_name(variable_name).map(&:destroy)
      end

      def build_field_attributes(repeater_field)
        attributes = {}

        attributes[:type] = repeater_field[:type] if transferable(repeater_field[:type])
        attributes[:json_config] = repeater_field[:json_config] if repeater_field[:json_config].present?

        attributes
      end

      def transferable(field_type)
        Field::TRANSFERABLE_TYPES.include?(field_type)
      end

      def config_was
        was = if json_config_was.is_a?(String)
                JSON.parse(json_config_was)
              else
                json_config_was
              end

        was.with_indifferent_access
      end

      # Track which variables have been deleted so that we do not try and update their attributes
      def deleted_variables
        @deleted_variables ||= []
      end
    end
  end
end
