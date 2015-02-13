require 'rails_helper'

RSpec.describe WorksHelper, type: :helper do
  let(:venue) { Venue.where(name: "Thomas Theatre").first_or_initialize }
  let(:work) { Work.new(work_name: "Hamlet", language: "en", venue: venue) }

  describe "#work_details" do
    context "for a work with texts" do
      let(:element) { Element.new }

      before do
        work.texts << Text.new(element: element, sequence: 1)
      end

      it "returns the name and language" do
        expect(work_details(work)).to eq "Hamlet: en (1 text)"
      end
    end

    context "for a work without texts" do
      it "returns the name and language" do
        expect(work_details(work)).to eq "Hamlet: en"
      end
    end
  end
end
