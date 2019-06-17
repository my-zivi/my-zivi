# frozen_string_literal: true

class TemplatePdfGeneratorService
  def initialize(template, pdf_locals, orientation)
    @template = template
    @pdf_locals = pdf_locals
    @orientation = orientation
  end

  def generate_pdf
    pdf_html = ActionController::Base.new.render_to_string(template: @template, layout: 'pdf', locals: @pdf_locals)
    WickedPdf.new.pdf_from_string(pdf_html, orientation: @orientation)
  end
end
