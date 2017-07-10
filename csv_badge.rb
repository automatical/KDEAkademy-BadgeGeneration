#!/usr/bin/ruby

require 'prawn'
require 'prawn/measurement_extensions'
require 'barby'
require 'barby/barcode/code_128'
require 'barby/barcode/ean_8'
require 'barby/outputter/prawn_outputter'
require 'csv'

CSV.foreach("registrations.csv") do |row|
  userid = row[0].to_i
  ircnick = row[1]
  name = row[2] + " " + row[3]
  aBarcode = Barby::EAN8.new((userid + 1000000).to_s.gsub("100", "000"))

  Prawn::Document.generate(name + ".pdf", :page_size => [180.mm, 180.mm], :margin => 0) do |pdf|
    pdf.font("/usr/share/fonts/truetype/freefont/FreeSansBold.ttf")
    pdf.text_box name, :at => [10.mm,165.mm], :height => 18.mm, :width => 70.mm, :size => 24, :align => :center, :overflow => :shrink_to_fit, :min_font_size => 14
    pdf.text_box name, :at => [100.mm,165.mm], :height => 18.mm, :width => 70.mm, :size => 24, :align => :center, :overflow => :shrink_to_fit, :min_font_size => 14
    if ircnick.length > 2
      if ircnick[0,1] == '.'
        ircnick = ircnick[1..-1]
      end
      pdf.font("/usr/share/fonts/truetype/freefont/FreeSansBoldOblique.ttf")
      pdf.text_box ircnick, :at => [10.mm,148.mm], :height => 10.mm, :width => 70.mm, :size => 18, :align => :center, :overflow => :shrink_to_fit, :min_font_size => 14
      pdf.text_box ircnick, :at => [100.mm,148.mm], :height => 10.mm, :width => 70.mm, :size => 18, :align => :center, :overflow => :shrink_to_fit, :min_font_size => 14
    end
    aBarcode.annotate_pdf(pdf, :x => 34.mm, :y => 136.mm, :height => 4.mm)
    aBarcode.annotate_pdf(pdf, :x => 124.mm, :y => 136.mm, :height => 4.mm)
  end
end
