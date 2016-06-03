module AboutHelper
  def topic_section(topic_name)
    find('article', text: topic_name)
  end

  def topic_results
    find('.topics-search')
  end

  def first_topic_result
    within(topic_results) do
      first('li')
    end
  end
end
