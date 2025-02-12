class Cart < ApplicationRecord
  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado
  scope :active, -> { where("updated_at >= ?", 3.hours.ago) }
  scope :abandoned, -> { where("updated_at < ?", 3.hours.ago) }
  scope :older_than, ->(time) { where("updated_at < ?", time) }

  def mark_as_abandoned
    @cart.update(status: 'abandoned', older_than: 3.hours.ago)
  end

  def delete_abandoned
    @cart.destroy if @cart.abandoned? && @cart.updated_at < 7.hours.ago
  end
end
