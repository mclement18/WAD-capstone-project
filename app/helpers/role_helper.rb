module RoleHelper
  def can_edit?(resource)
    case current_user.role
    when 'admin' then true
    when 'registered' then current_user.id == resource.try(:user_id)
    else false
    end
  end

  def current_user_role
    if logged_in?
      current_user.role
    else
      'anonymous'
    end
  end
end
