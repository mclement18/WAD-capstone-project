module RoleHelper
  def can_edit?(resource)
    case current_user.role
    when 'admin' then true
    when 'registered' then current_user.id == resource.try(:user_id)
    else false
    end
  end
end
