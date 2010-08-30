class Guest
  include Role::Guest
  
  def guest?
    true
  end
end
