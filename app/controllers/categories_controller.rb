class CategoriesController < ApplicationController
  before_filter :parse_json_body, only: %w(create update)
  before_filter :find_owned_resources, only: 'index'
  before_filter :find_public_resources, only: 'public'
  before_filter :find_resource, only: 'show'
  before_filter :find_owned_resource, only: %w(update destroy)

  def index
    @categories =  @categories.page(params[:page]).per(params[:per])
  end

    def public
      @categories =  @categories.page(params[:page]).per(params[:per])
      render '/categories/index'
    end

  def show
  end

  def create
    @category = Category.base(json_body, request, current_user)
    if @category.save
      render "show", status: 201, location: @category.uri
    else
      render_422 "notifications.document.not_valid", @category.errors
    end
  end

  def update
    if @category.update_attributes(json_body)
      render "show"
    else
      render_422 "notifications.document.not_valid", @category.errors
    end
  end

  def destroy
    @category.destroy
    render 'show'
  end


  private

    def find_public_resources
      @categories = Category.where(public: true)
    end

    def find_owned_resources
      @categories = Category.where(created_from: current_user.uri)
    end

    def find_owned_resource
      @category = Category.where(created_from: current_user.uri).find(params[:id])
    end

    def find_resource
      @category = Category.where(_id: params[:id]).first
      if @category
        if not @category.public
          if current_user 
            if not @category.created_from == current_user.uri
              render_404 'notifications.document.not_found', {id: params[:id]}
            end
          else
            render_401
          end
        end
      else
        render_404 'notifications.document.not_found', {id: params[:id]}
      end
    end
end
