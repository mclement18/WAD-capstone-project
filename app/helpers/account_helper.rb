module AccountHelper
  def is_current?(current, link)
    'current' if current == link
  end
end
