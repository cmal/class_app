# coding: utf-8
class KlassesController < ApplicationController

  def index
    @klasses = Klass.all.paginate(page: params[:page])
  end

  def show
    @klass = Klass.find(params[:id])
    @members = @klass.members.paginate(page: params[:page])
  end

  def new
    @klass = Klass.new
  end
  
  def create
    @klass = Klass.new(klass_params)
    if @klass.save
      flash[:success] = "已添加班级！"
      redirect_to 'index'
    else
      render 'new'
    end
  end

  def edit
    @klass = Klass.find(params[:id])
  end

  def update
    @klass = Klass.find(params[:id])
    @klass.update_attributes(klass_params)
    if @klass.save
      redirect_to @klass
    else
      render 'edit'
    end
  end

  private

  def klass_params
    params.require(:klass).permit(:name)
  end
end
