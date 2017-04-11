module Admin
  module Content
    class PagesController < ::Admin::ResourceController
      before_action :build_field_associations, only: [:create, :update]

      def create
        new_record = @object.new_record?

        # remove a leading / on the slug
        permitted_params[:slug].sub! %r{^\/}, ""

        @object.update_attributes(permitted_params)

        return redirect_to edit_admin_content_page_path(@object) if new_record

        respond_with :admin, admin_responder
      end
      alias_method :update, :create

      protected

      def build_field_associations
        @object.fields.map(&:build_associations)
      end
    end
  end
end
