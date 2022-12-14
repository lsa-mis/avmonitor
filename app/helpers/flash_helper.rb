module FlashHelper
  def css_class_for_flash(type)
    case type.to_sym
    when :alert
      "bg-red-100 text-red-700"
    else
      "bg-green-100 text-green-700"
    end
  end
end