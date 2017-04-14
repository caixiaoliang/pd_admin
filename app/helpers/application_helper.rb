module ApplicationHelper

  def admin?
    current_user.try(:admin)
  end
  def active_class(val)
    return "active" if controller_name == val
  end

end
