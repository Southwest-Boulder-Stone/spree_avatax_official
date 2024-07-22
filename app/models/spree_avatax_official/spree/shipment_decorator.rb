module SpreeAvataxOfficial
  module Spree
    module ShipmentDecorator
      delegate :tax_zone, to: :order

      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def included_in_price
        tax_zone.try(:included_in_price) || false
      end

      def tax_category
        selected_shipping_rate.try(:tax_rate).try(:tax_category) || shipping_method.try(:tax_category)
      end

      def avatax_tax_code
        tax_category.try(:tax_code).presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['Shipment']
      end

      def tax_address
        shipping_methods.first.delivery_class == 'pickup' ? stock_location : order.tax_address
      end
    end
  end
end

::Spree::Shipment.prepend ::SpreeAvataxOfficial::Spree::ShipmentDecorator
