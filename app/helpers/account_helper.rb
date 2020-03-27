module AccountHelper
  def is_current?(current, link)
    'current' if current == link
  end

  def account_not_updated?
    current_user.created_at == current_user.updated_at
  end
end
