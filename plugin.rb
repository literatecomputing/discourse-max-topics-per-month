# frozen_string_literal: true

# name: discourse-max-topics-per-month
# about: limiting number of topics per month
# version: 0.1
# authors: pfaffman
# url: https://github.com/pfaffman/discourse-max-topics-per-month

enabled_site_setting :max_topics_per_month_enabled

PLUGIN_NAME ||= 'max_topics_per_month'

# See discourse-assign for good examples of serializer, callback, adding method
after_initialize do

  add_to_serializer(:user, :remaining_topics_this_month, false) do
    SiteSetting.max_topics_per_month - Topic.where(user_id: object.id).where("created_at > ?", 1.month.ago).count
  end

  add_to_serializer(:current_user, :saved_searches, false) do
    (object.name)
  end

  require_dependency "topic"
  class ::Topic < ActiveRecord::Base
    rate_limit :limit_topics_per_month

    def limit_topics_per_month
      apply_per_month_rate_limit("topics", :max_topics_per_month)
    end

    def apply_per_month_rate_limit(key, method_name)
      RateLimiter.new(self.user, "#{key}-per-month", SiteSetting.get(method_name), 1.month.to_i)
    end
  end
end
