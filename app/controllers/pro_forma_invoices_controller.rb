class ProFormaInvoicesController < ApplicationController

  protect_from_forgery except: [:pro_forma_preview]

  def pro_forma_preview
    @pro_forma_invoice = ProFormaInvoice.new
    @pro_forma_invoice.client_name = params[:client_name]
    @pro_forma_invoice.client_address = params[:client_address]
    @pro_forma_invoice.invoiced_on = Date.today

    @pro_forma_invoice.itinerary_charges = params[:itinerary_charges]

    @pro_forma_invoice.handling_charges = params[:handling_charges]

    @pro_forma_invoice.accommodation_charges = params[:accommodation_charges]

    @pro_forma_invoice.miscellaneous_charges = params[:miscellaneous_charges]

    @pro_forma_invoice.service_tax = 14.5
    @pro_forma_invoice.other_tax_name = 'Swachh Bharat Cess'
    # @pro_forma_invoice.other_tax = 0.5
    @pro_forma_invoice.show_itineraries_on_pdf = true
    send_data WickedPdf.new.pdf_from_string(
                  render_to_string 'pro_forma_invoices/show_2.html.erb', layout: 'pdf_2'
              )
  end

end