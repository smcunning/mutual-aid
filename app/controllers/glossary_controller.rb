class GlossaryController < PublicController
  include Pundit

  before_action :set_system_settings

  def show; end
  def edit
    authorize :glossary, :update?
  end

  def update
    if authorize :glossary, :update?
      @system_settings.update!(glossary_params)
      redirect_to glossary_path
    end
  end

  private

  def glossary_params
    params.require(:system_setting).permit(:glossary_content)
  end

  def set_system_settings
    @system_settings = SystemSetting.current_settings
  end
end
