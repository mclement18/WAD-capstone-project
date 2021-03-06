module ApplicationHelper
  include ActiveSupport
  
  def alert_id
    if @alert_id.present?
      return @alert_id
    end
    @alert_id = "alert-id-#{SecureRandom.hex}"
  end

  def image_set_tag(source, srcset = {}, options = {})
    srcset = srcset.map { |src, size| "#{path_to_image(src)} #{size}" }.join(', ')
    image_tag(source, options.merge(srcset: srcset))
  end

  def pluralize_better(word, count)
    if count == 0 || count == 1
      word
    else
      Inflector.pluralize(word)
    end
  end
end
