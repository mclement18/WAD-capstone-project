module ApplicationHelper
  def alert_id
    if @alert_id.present?
      return @alert_id
    end
    @alert_id = SecureRandom.hex
  end
end
