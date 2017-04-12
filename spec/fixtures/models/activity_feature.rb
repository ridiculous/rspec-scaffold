class ActivityFeature < ActiveRecord::Base
  include LocaleLabelExt

  before_save :assign_sequencer

  attr_accessible :identifier, :image_name, :sequencer
  attr_accessible :activity, :activity_id
  attr_accessible :notification

  translates :notification
  globalize_accessors locales: I18n.available_locales, attributes: [:notification]

  belongs_to :activity
  has_one :section_set, through: :activity
  has_one :section, through: :activity

  validates :image_name, presence: true

  scope :order_by_sequencer_asc, -> { order sequencer: :asc }
  scope :order_by_sequencer_desc, -> { order sequencer: :desc }

  def self.localized_fields
    ["notification"]
  end

  def image
    "activity_features/#{image_name}"
  end

  private
    def assign_sequencer
      return if self.sequencer.present?
      fetched_sequencer = self.activity.activity_features.pluck(:sequencer).uniq.sort.last
      self.sequencer = (fetched_sequencer.presence || 0).next
    end

end
