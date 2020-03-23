module ApplicationHelper
  def alert_id
    if @alert_id.present?
      return @alert_id
    end
    @alert_id = SecureRandom.hex
  end

  def image_set_tag(source, srcset = {}, options = {})
    srcset = srcset.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
    image_tag(source, options.merge(srcset: srcset))
  end
end
