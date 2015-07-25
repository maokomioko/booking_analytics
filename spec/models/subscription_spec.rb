require 'rails_helper'

describe Payment::Subscription do
  context 'association' do
    it { should have_and_belong_to_many(:payment_items) }
    it { should accept_nested_attributes_for(:payment_items) }

    it { should belong_to(:company) }
  end
end
