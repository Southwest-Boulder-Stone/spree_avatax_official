module SpreeAvataxOfficial
  module HasUuid
    AVATAX_CODES = {
      'LineItem' => 'LI',
      'Shipment' => 'FR'
    }.freeze

    def self.included(base)
      base.before_create :generate_uuid
    end

    def avatax_number
      "#{AVATAX_CODES[self.class.name.demodulize]}-#{avatax_uuid}"
    end

    private

    def generate_uuid
      return unless avatax_uuid.blank?

      self.avatax_uuid = SecureRandom.uuid
    end
  end
end
