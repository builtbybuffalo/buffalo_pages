module Admin
  module Content
    class PageBlueprintsController < Admin::ResourceController
      def export
        blueprints.each do |blueprint|
          processed = blueprint.attributes.except("id", "created_at", "updated_at")

          processed[:field_blueprints] = blueprint.field_blueprints.map(&:attributes).map do |field|
            field.except!("id", "created_at", "updated_at", "page_blueprint_id")

            if field["json_config"].present?
              field["json_config"] = JSON.parse(field["json_config"].gsub(/\r\n/, "").strip)
            end

            field
          end

          (@page_blueprints ||= []) << processed
        end
      end

      # Update page and field blueprints without using ID's as reference
      # rubocop:disable Metrics/AbcSize
      def process_import
        JSON.parse(import_params.dig(:json)).each do |record|
          record = record.with_indifferent_access

          begin
            blueprint = process_blueprint(record)
          rescue ActiveRecord::RecordInvalid => invalid
            flash[:error] = "#{record[:name]}: #{invalid.message}. #{t('admin.import_blueprint_invalid')}"

            return render :import
          end

          process_field_blueprints(blueprint, record)
        end

        redirect_to admin_content_page_blueprints_path, flash: { success: t("admin.import_ok", log: @log.join(", ")) }
      end
      # rubocop:enable Metrics/AbcSize

      protected

      def process_blueprint(record)
        args = { name: record[:name], template: record[:template] }

        blueprint = ::Content::PageBlueprint.where(args).first_or_create
        blueprint.update_attributes!(record.except(:field_blueprints))

        log(blueprint.name)

        blueprint
      end

      def process_field_blueprints(blueprint, params)
        blueprint.field_blueprints.build unless blueprint.field_blueprints.present?

        params.dig(:field_blueprints).each do |attrs|
          # To aid readability, the export script pretty prints the json_config, it needs to be converted before update
          attrs[:json_config] = attrs[:json_config].to_json if attrs[:json_config].present?

          field = blueprint.field_blueprints.where(variable_name: attrs[:variable_name]).first_or_create
          field.update_attributes(attrs)
        end
      end

      def import_params
        params.require(:import).permit(:json)
      end

      def log(message)
        (@log ||= []) << message
      end

      def blueprints
        default_query = ::Content::PageBlueprint.includes(:field_blueprints)

        if params[:page_blueprint_id].present?
          default_query.where(id: params[:page_blueprint_id])
        else
          default_query.all
        end
      end

      def not_loadable_actions
        [:export, :import, :process_import]
      end
    end
  end
end
