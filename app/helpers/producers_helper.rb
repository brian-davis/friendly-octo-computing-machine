module ProducersHelper
  def life_line(producer)
    lifetime = if (producer.year_of_birth || producer.year_of_death)
      [
        common_era_year(producer.year_of_birth),
        common_era_year(producer.year_of_death)
      ].map(&:presence).join(" — ") # 1 side empty OK
    end

    [producer.nationality, lifetime].map(&:presence).compact.join(", ")
  end
end