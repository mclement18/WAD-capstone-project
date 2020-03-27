module ToDosHelper
  def current_user_to_dos
    if @current_user_to_dos
      return @current_user_to_dos
    end
    @current_user_to_dos = current_user.to_dos
  end

  def current_user_to_do(trip_id)
    current_user_to_dos.each do |todo|
      return todo if todo.trip_id == trip_id
    end
  end
  
  def is_a_current_user_todo?(trip)
    current_user_to_dos.each do |todo|
      return true if todo.trip_id == trip.id
    end
    false
  end

  def todo_update_button_name(transition)
    case transition
    when 'traveling' then 'Start'
    when 'arrived'   then 'Finish'
    when 'cancel'    then 'ToDo'
    end
  end

  def todo_update_button_class(transition)
    'btn--secondary' if transition == 'cancel'
  end
end
