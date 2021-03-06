# frozen_string_literal: true

class SubmissionResponseImportsController < AdminController
  def new; end

  def create
    uploaded_file = params[:submission_response_import][:file]

    SubmissionResponseImportJob.perform_later(
      user_id: current_user.id,
      file_name: uploaded_file.original_filename,
      file_contents: uploaded_file.read,
    )

    flash[:notice] = 'Your file has been uploaded and is being imported'
    redirect_to admin_dashboard_path
  end
end
