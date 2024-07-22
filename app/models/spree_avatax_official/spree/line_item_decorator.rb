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
        return super if !SpreeAvataxOfficial::Config.enabled || tax_unneeded?

        SpreeAvataxOfficial::CreateTaxAdjustmentsService.call(order: order)
      end

      def tax_unneeded?
        return true unless order.ready_for_tax_or_shipping_calculation?

        order.line_items.any?(&:quote_item?)
      end

      def avatax_tax_code
        tax_category.try(:tax_code).presence || ::Spree::TaxCategory::DEFAULT_TAX_CODES['LineItem']
      end

      def tax_address
        pickup? ? stock_location : order.tax_address
      end
    end
  end
end

::Spree::LineItem.prepend ::SpreeAvataxOfficial::Spree::LineItemDecorator
