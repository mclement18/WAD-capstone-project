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
end
