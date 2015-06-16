shared_examples_for 'a reservation JSON response' do
  describe 'hash' do
    it 'have required keys' do
      keys = hash.keys
      required = %i(
        arrival departure created_at room_ids room_amount price status adults
        children contact_phone contact_email
      )

      expect(keys).to include(*required)
    end

    # DateTime keys
    %i(arrival departure created_at).each do |key|
      it "validates #{ key }" do
        expect(hash[key]).to be_a DateTime
      end
    end

    # Integer keys
    %i(room_amount adults children).each do |key|
      it "validates #{ key }" do
        expect(hash[key]).to be_a Integer
      end
    end

    # String keys
    %i(status contact_phone contact_email).each do |key|
      it "validates #{ key }" do
        expect(hash[key]).to be_a String
      end
    end

    it 'validates room_ids' do
      expect(hash[:room_ids]).to be_a Array
      expect(hash[:room_ids].reject{|id| id.is_a?(Integer)}.count).to eq 0
    end

    it 'validates price' do
      expect(hash[:price]).to be_a Money
    end
  end
end