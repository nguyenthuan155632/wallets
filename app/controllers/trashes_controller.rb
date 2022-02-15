class TrashesController < ApplicationController
  before_action :set_trash, only: %i[edit update destroy]

  # GET /trashes or /trashes.json
  def index
    @trashes = Trash.all
  end

  # GET /trashes/new
  def new
    @trash = Trash.new
  end

  # GET /trashes/1/edit
  def edit; end

  # POST /trashes or /trashes.json
  def create
    @trash = Trash.new(trash_params)

    respond_to do |format|
      if @trash.save
        format.html { redirect_to trashes_url, notice: "Trash was successfully created." }
        format.json { render :show, status: :created, location: @trash }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @trash.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trashes/1 or /trashes/1.json
  def update
    respond_to do |format|
      if @trash.update(trash_params)
        format.html { redirect_to trashes_url, notice: "Trash was successfully updated." }
        format.json { render :show, status: :ok, location: @trash }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @trash.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trashes/1 or /trashes/1.json
  def destroy
    @trash.destroy

    respond_to do |format|
      format.html { redirect_to trashes_url, notice: "Trash was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trash
      @trash = Trash.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def trash_params
      params.require(:trash).permit(:contract_name)
    end
end
