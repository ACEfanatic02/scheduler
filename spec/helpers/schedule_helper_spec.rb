require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ScheduleHelper. For example:
#
# describe ScheduleHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ScheduleHelper do

  describe '#hours_for_day' do
    let(:today) { Time.now.midnight }

    describe 'return value' do
      it 'contains the right number of times' do
        expect(hours_for_day(today, 8, 10).count).to eq(3)
      end

      it 'provides times on the given day' do
        hours_for_day(today, 8, 10).each do |time|
          expect(time.midnight).to eq(today)
        end
      end
    end
  end
end
