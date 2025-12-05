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

      self.avatax_uuid = 
        if self.class.name.demodulize == 'LineItem'
          SecureRandom.uuid
        else
          Digest::UUID.uuid_v3(AVATAX_CODES[self.class.name.demodulize], "#{self.order.number}-#{self.shipping_method.id}")
        end
    end
  end
end
