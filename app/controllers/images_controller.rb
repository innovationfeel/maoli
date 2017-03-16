class ImagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project

  def create
    add_more_images(images_params[:images])
    flash[:error] = 'Failed uploading images' unless @project.save
    redirect_to :back
  end

  def destroy
    remove_image_at_index(params[:id].to_i)
    flash[:error] = 'Failed deleting image' unless @project.save
    redirect_to :back
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def add_more_images(new_images)
    images = @project.images # copy the old images 
    images += new_images # concat old images with new ones
    @project.images = images # assign back
  end

  def remove_image_at_index(index)
    remain_images = @project.images # copy the array
    deleted_image = remain_images.delete_at(index) # delete the target image
    deleted_image.try(:remove!) # delete image
    @project.images = remain_images # re-assign back
  end

  def images_params
    params.require(:project).permit({images: []}) # allow nested params as array
  end
end
