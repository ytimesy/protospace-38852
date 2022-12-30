class PrototypesController < ApplicationController
  before_action :authenticate_user! ,except: [ :index, :show ]
  #before_action :move_to_index, except: [ :index, :show ]

  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
        render :new
    end
  end

  def show
    @comment = Comment.new
    @prototype = Prototype.find(params[:id])
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])  
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])  
    prototype.destroy
    redirect_to root_path  
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end 

  def move_to_index
    unless Prototype.find(params[:id]).user == current_user
      redirect_to action: :index
    end
  end


end
