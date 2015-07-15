require 'rails_helper'

describe Payment::Subscription do
  context 'association' do
    it { should have_and_belong_to_many(:payment_items) }
    it { should belong_to(:company) }
  end

  context 'scopes' do
  end
end
