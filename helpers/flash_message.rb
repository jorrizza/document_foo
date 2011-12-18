helpers do
  def flash_message
    flash_msg = ''

    [:warning, :error, :success, :info].each do |level|
      if flash[level]
        @flash_level = level
        flash_msg += erb :flash_message
      end
    end

    flash_msg
  end
end
