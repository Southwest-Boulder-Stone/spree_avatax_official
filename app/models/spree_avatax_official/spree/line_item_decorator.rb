module SpreeAvataxOfficial
  module Spree
    module LineItemDecorator
      delegate :tax_zone, to: :order

      def self.prepended(base)
        base.include ::SpreeAvataxOfficial::HasUuid
      end

      def included_in_price
        tax_zone.try(:included_in_price) || false
      end

      def update_tax_charge
        return super unless SpreeAvataxOfficial::Config.enabled && !quote?

        SpreeAvataxOfficial::CreateTaxAdjustmentsService.call(order: order)
      end

      def quote?
        order.line_items.any? { |li| li.variant_per.price.zero? || li.variant_per.weight <= 0 }
      end

      def avatax_tax_code
        tax_category.try(:tax_code).presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['LineItem']
      end
    end
  end
end

::Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
