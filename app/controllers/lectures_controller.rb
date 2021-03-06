class LecturesController < ApplicationController
  before_action :set_lecture, only: [:show, :edit, :update, :destroy]

  # GET /lectures
  # GET /lectures.json
   def index
    if params[:tag]
          @lectures = Lecture.tagged_with(params[:tag])
    else
          @lectures = Lecture.all
          if params[:search]
            @lectures = Lecture.search(params[:search])|Lecture.tagged_with(params[:search])
            .order("created_at DESC")
          else
            @lectures = Lecture.all.order('created_at DESC')
          end
    end
  end

  def getlectures
    @lectures =Lecture.all.select { |l| l.user_id == current_user.id }
  end
  # GET /lectures/1
  # GET /lectures/1.json
  
  def show
    @slides = @lecture.slides.order(page_number: :asc)
  end

  # GET /lectures/new
  def new
    @lecture = Lecture.new
  end

  # GET /lectures/1/edit
  def edit
  end

  # Lecture /lectures
  # Lecture /lectures.json
  def create
    @lecture = Lecture.new(lecture_params)
    respond_to do |format|


      if @lecture.save
        format.html { redirect_to @lecture, notice: 'Lecture was successfully created.' }
        format.json { render :show, status: :created, location: @lecture }
      else
        format.html { render :new }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lectures/1
  # PATCH/PUT /lectures/1.json
  def update
    respond_to do |format|
      if @lecture.update(lecture_params)
        format.html { redirect_to @lecture, notice: 'Lecture was successfully updated.' }
        format.json { render :show, status: :ok, location: @lecture }
      else
        format.html { render :edit }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lectures/1
  # DELETE /lectures/1.json
  def destroy
    @lecture.destroy
    respond_to do |format|
      format.html { redirect_to lectures_url, notice: 'Lecture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lecture
      @lecture = @commentable = Lecture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lecture_params
      params.require(:lecture).permit(:name , :attachment , :tag_list ,:user_id) if params[:lecture]
    end
end
