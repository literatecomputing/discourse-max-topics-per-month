# encoding: utf-8
# frozen_string_literal: true

require 'rails_helper'
# this doesn't actually work
describe Topic do
  let(:now) { Time.zone.local(2013, 11, 20, 8, 0) }
  fab!(:user) { Fabricate(:user) }
  fab!(:another_user) { Fabricate(:user) }
  fab!(:trust_level_2) { Fabricate(:user, trust_level: TrustLevel[2]) }

  it { is_expected.to rate_limit }

  context "per month personal message limit" do
    before do
      SiteSetting.max_topics_per_month_enabled = true
      SiteSetting.max_topics_per_month = 1
      RateLimiter.enable
    end

    after do
      RateLimiter.clear_all!
      RateLimiter.disable
    end

    skip "limits according to max_topics_per_month" do
      user1 = Fabricate(:user)
      create_post(user: user, archetype: 'private_message', target_usernames: [user1.username, user2.username])
      expect {
        create_post(user: user, archetype: 'private_message', target_usernames: [user1.username, user2.username])
      }.to raise_error(RateLimiter::LimitExceeded)
    end
  end
end
