module UsersHelper
  def block_unblock_user_button_text(user)
    user.active ? 'Block' : 'Unblock'
  end
end
