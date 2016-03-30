class Organisations::OrganisationDocumentsController < Organisations::BaseController

  before_action :authenticate_operator

  before_action :find_document, only: [:destroy]

  def index
    @documents = current_organisation.organisation_documents
  end

  def create
    @organisation_document = current_organisation.organisation_documents.new(params[:organisation_document].permit!)
    if @organisation_document.save
      render status: :ok
    else
      render status: :unprocessable_entity, json: { errors: @organisation_document.errors.full_messages }
    end
  end

  def destroy
    @document.destroy
    render status: :ok, nothing: true
  end

  private

  def find_document
    @document = current_organisation.organisation_documents.find params[:id]
  end

end