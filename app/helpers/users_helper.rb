module UsersHelper
  def change_msg_keys!(msg)
    msg.keys.each do |k|
      if ["password", "password_confirmation"].include?(k)
        msg.store(("new_"+k.to_s).to_sym, msg.delete(k))
      end
    end
  end
end
