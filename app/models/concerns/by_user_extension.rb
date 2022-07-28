module ByUserExtension
  def by_user(user)
    where(user_id: user)
  end
end