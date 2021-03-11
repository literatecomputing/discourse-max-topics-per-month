# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'

describe Topic do
  let(:now) { Time.zone.local(2013, 11, 20, 8, 0) }
  fab!(:user) { Fabricate(:user) }

  context "per month topic limit" do
    before do
      SiteSetting.max_topics_per_month_enabled = true
      SiteSetting.max_topics_per_month = 1
      RateLimiter.enable
    end

    after do
      RateLimiter.clear_all!
      RateLimiter.disable
    end

    it "limits according to max_topics_per_month" do
      create_post(user: user)
      expect { create_post(user: user) }.to raise_error(RateLimiter::LimitExceeded)
    end
    
    it "works in the following month" do
      create_post(user: user)
      freeze_time(Time.now.next_month)
      
      expect{ create_post(user: user) }.not_to raise_error
      expect{ create_post(user: user) }.to raise_error(RateLimiter::LimitExceeded)
    end
  end
end
