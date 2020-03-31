module UsersHelper
  def role_options(selected)
    options_for_select [
                         [t('users.roles.registered'), 'registered'], 
                         [t('users.roles.admin'), 'admin']
                       ],
                       selected
  end
  
  def remote_delete?(user, remote)
    return current_user != user if remote
    false 
  end

  def user_link_path(user)
    if user.deleted
      return 'javascript:;'
    else
      return user_path(user)
    end
  end

  def user_link_class(user)
    'user-deleted' if user.deleted
  end
end
