class Event < ActiveRecord::Base
  has_many :tickets, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  mount_uploader :event_image, EventImageUploader

	validates :name, length: { maximum: 50  }, presence: true
	validates :place, length: { maximum: 100  }, presence: true
	validates :content, length: { maximum: 2000  }, presence: true
	validates :start_time, presence: true
	validates :end_time, presence: true
	validate :start_time_should_be_before_end_time

  def created_by?(user)
    return false unless user
    owner_id == user.id
  end

  def self.ransackable_attributes(auth_object = nil)
    %w(name start_time)
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def rails?
    !!(name =~ /Rails/)
  end

	private
	
		def start_time_should_be_before_end_time
			return unless start_time && end_time
			
			if start_time >= end_time
				errors.add(:start_time, 'は終了時間よりも前に設定してください')
			end	
		end 

end
