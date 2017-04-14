class TagsController < ApplicationController
  before_action :check_login
  def new
    @tag = Tag.new
  end
  
  def index
    @tags = Tag.all.paginate(page: params[:page],per_page: 20)
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path
    else
      render :new
    end
  end

  def edit
    id = params[:id]
    @tag = Tag.find(id)
  end

  def update
    id = params[:id]
    @tag = Tag.find(id)
    if @tag.update_attributes(tag_params)
      redirect_to tags_path
    else
      render :edit
    end
  end

  def destroy
    id = params[:id]
    @tag = Tag.find(id)
    @tag.destroy
    redirect_to :index
  end
   private 
    def tag_params
      params.require(:tag).permit(:name)
    end
end
