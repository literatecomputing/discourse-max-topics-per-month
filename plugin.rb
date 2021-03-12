# frozen_string_literal: true

# name: discourse-max-topics-per-month
# about: limiting number of topics per month
# version: 0.1
# authors: pfaffman
# url: https://github.com/literatecomputing/discourse-max-topics-per-month

enabled_site_setting :max_topics_per_month_enabled

# See discourse-assign for good examples of serializer, callback, adding method
after_initialize do

  add_to_serializer(:current_user, :remaining_topics_this_month) do
    object.remaining_topics_this_month
  end

  add_to_class(:user, :remaining_topics_this_month) do
    [0, (SiteSetting.max_topics_per_month - Topic.where(user_id: self.id).where("created_at > ?", 1.month.ago).count)].max
  end

  add_to_class(:topic, :limit_topics_per_month) do
    apply_per_month_rate_limit("topics", :max_topics_per_month)
  end

  add_to_class(:topic, :apply_per_month_rate_limit) do |key, method_name|
    RateLimiter.new(self.user, "#{key}-per-month", SiteSetting.get(method_name), 1.month.to_i)
  end

  Topic.rate_limit(:limit_topics_per_month)
end
