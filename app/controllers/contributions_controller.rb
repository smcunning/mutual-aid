class ContributionsController < ApplicationController
  before_action :authenticate_user!, except: [:combined_form, :respond, :thank_you]
  before_action :set_contribution, only: [:respond, :triage]

  layout "without_navbar", only: [:thank_you]

  def index
    @filter_types = BrowseFilter.filter_options_json
    # The BrowserFilter takes the result of the parameters that match the filter_type options and returns a list of contributions
    filter = BrowseFilter.new(allowed_params, self)
    @contributions = ContributionBlueprint.render(filter.contributions, **filter.options)
    respond_to do |format|
      format.html
      format.json { render inline: @contributions }
    end
  end

  def combined_form
  end

  def respond
    @communication_logs = CommunicationLog.where(person: @contribution.person).order(sent_at: :desc)
  end

  def thank_you
  end

  def triage
  end

  def triage_update
    @contribution = Listing.find(params[:id])
    contribution_params = params[@contribution.type.downcase.to_sym]
    title = contribution_params[:title]
    description = contribution_params[:description]
    inexhaustible = contribution_params[:inexhaustible]

    if @contribution.update(title: title, description: description, inexhaustible: inexhaustible)
      # CommunicationLog.create!(person: @contribution.person,
      #                          sent_at: Time.current,
      #                          subject: "triaged by #{current_user.name}",
      #                          delivery_status: "connected",
      #                          delivery_method: @contribution.person.preferred_contact_method)
      redirect_to respond_contribution_path(@contribution), notice: 'Contribution was successfully updated.'
    else
      render triage_contribution_path(@contribution)
    end
  end

  private

  def allowed_params
    params.permit(:format, BrowseFilter::ALLOWED_PARAMS_FILTER)
  end

  def set_contribution
    @contribution = Listing.find(params[:id])
  end
end
