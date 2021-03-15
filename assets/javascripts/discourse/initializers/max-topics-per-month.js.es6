import { withPluginApi } from "discourse/lib/plugin-api";
import discourseComputed from "discourse-common/utils/decorators";

export default {
  name: "max-topics-per-month",
  initialize() {
    withPluginApi("0.8.30", (api) => {
      api.modifyClass("component:create-topic-button", {
        @discourseComputed("currentUser.remaining_topics_this_month")
        disabled(remainingTopics) {
          if (
            this.siteSettings.max_topics_per_month_enabled &&
            this.siteSettings.max_topics_per_month_enabled_ux
          ) {
            return Number(remainingTopics) < 1;
          } else {
            return this._super(...arguments);
          }
        },
      });
    });
  },
};
