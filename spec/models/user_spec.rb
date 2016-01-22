require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do

    it 'has a valid factory' do

      expect( build(:user) ).to be_valid

    end

  end

end
