module ProducersHelper
  def life_line(producer)
    lifetime = if (producer.birth_year || producer.death_year)
      [
        common_era_year(producer.birth_year),
        common_era_year(producer.death_year)
      ].map(&:presence).join(" — ") # 1 side empty OK
    end

    [producer.nationality, lifetime].map(&:presence).compact.join(", ")
  end
end