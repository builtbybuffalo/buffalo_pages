module Admin
  module Content
    class ImageUploadsController < ResourceController
      def create
        asset.update_attribute(:asset, asset_params)
        attachable_from_params.images << asset

        return render json: { file: { url: asset.asset.url } }.to_json, status: 200 if asset.persisted?
      end

      protected

      def load_object; end

      def attachment_params
        params.require("attachment")
      end

      def asset_params
        attachment_params.require(:asset)
      end

      def attachable_params
        attachment_params.permit(:attachable_type, :attachable_id)
      end

      def attachable_from_params
        attachable_params[:attachable_type].constantize.find(attachable_params[:attachable_id])
      end

      def asset
        @asset ||= Asset.new
      end
    end
  end
end
