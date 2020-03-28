module AccountHelper
  def current_class(current, link)
    'current' if current == link
  end
  
    def sub_nav_link_path(path, current, link)
      if current == link
        return 'javascript:;'
      else
        return path
      end
    end

  def account_not_updated?
    current_user.created_at == current_user.updated_at
  end
end
