module Users::LotteriesHelper
  def progress(item)
    [(item.bets.where(batch_count: item.batch_count).betting.count.to_f/item.minimum_bets) * 100, 100].min.to_i
  end
end
