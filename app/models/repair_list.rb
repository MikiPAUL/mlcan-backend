class RepairList < ApplicationRecord
    has_one :merc_repair_type
    has_one :non_maersk_repair
    has_many :activity_repair_lists
    enum repair_type: { non_maersk: 0, merc: 1}

    scope :most_recent_by_updates, -> do
        from(
          <<~SQL
            (
              SELECT repair_lists.*
              FROM repair_lists JOIN (
                 SELECT repair_number, max(version) AS version
                 FROM repair_lists
                 GROUP BY repair_number
              ) latest_by_updates
              ON repair_lists.version = latest_by_updates.version
              AND repair_lists.repair_number = latest_by_updates.repair_number
            ) repair_lists
          SQL
        )
    end
end
