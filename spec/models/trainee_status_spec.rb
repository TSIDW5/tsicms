require 'rails_helper'

RSpec.describe TraineeStatus, type: :model do
  describe 'validates' do
    it {is_expected.to validate_presence_of(:name)}
  end
end
