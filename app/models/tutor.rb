class Tutor < ActiveRecord::Base
  belongs_to :user

  has_many :appointments
  has_many :clients, through: :appointments

  has_and_belongs_to_many :subjects

  after_create do |tutor|
    other = Subject.find_or_create_by(course_number: "Other") do |subject|
      subject.course_name = "Other"
    end

    tutor.subjects << other
  end

  def schedule_for(day, start_hour, end_hour)
    start_time = day.change(hour: start_hour)
    end_time = day.change(hour: end_hour)

    TutorDaySchedule.new(self, day, start_time, end_time)
  end

  class TutorDaySchedule

    include Enumerable

    def initialize(tutor, day, start_time, end_time)
      @tutor = tutor
      @day = day
      @start_time = start_time
      @end_time = end_time
      @blocks = []
      @tutor.appointments.where('start_time >= ? and end_time <= ?', start_time, end_time).each do |appt|
        @blocks << appt
      end
    end
    
    def each
      cur = @start_time
      until cur >= @end_time do
        if block = get_block(cur)
          yield ({
            length: block.length / 15,
            type: :appointment,
            time: cur,
            contents: block,
          })
          cur = cur.advance(minutes: block.length)
        else
          yield ({
            length: 1,
            type: :open,
            time: cur,
            contents: nil,
          })
          cur = cur.advance(minutes: 15)
        end
      end
    end

    private 

    def get_block(time)
      @blocks.each do |block|
        begin
          if block.start_time == time
            return block
          end
        rescue NoMethodError
          next
        end
      end
      nil
    end
  end
end
