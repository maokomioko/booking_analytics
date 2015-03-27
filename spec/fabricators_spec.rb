require 'rails_helper'

Fabrication.manager.load_definitions if Fabrication.manager.empty?
Fabrication.manager.schematics.keys.each do |fabricator_name|
  describe "The #{ fabricator_name } fabricator" do
    it 'is valid' do
      expect(Fabricate(fabricator_name.to_sym)).to be_valid
    end
  end
end
