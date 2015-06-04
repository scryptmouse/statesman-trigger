%w[connection schema models].each do |f|
  require_relative "./#{f}"
end
