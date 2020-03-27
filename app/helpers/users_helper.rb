module UsersHelper
  def remote_delete?(user, remote)
    return current_user != user if remote
    false 
  end
end
