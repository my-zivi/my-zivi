# frozen_string_literal: true

module CivilServantSearchable
  WORD_SIMILARITY_QUERY = <<~SQL.squish
    (POWER(word_similarity(civil_servants.first_name, :term), 2) +
    POWER(word_similarity(civil_servants.last_name, :term), 2) +
    POWER(word_similarity(users.email, :term), 2) +
    (CASE WHEN civil_servants.first_name ILIKE :begins_with_term THEN 0.5 ELSE 0 END) +
    (CASE WHEN civil_servants.last_name ILIKE :begins_with_term THEN 0.5 ELSE 0 END))
  SQL

  WORD_SIMILARITY_SELECT_QUERY = <<~SQL.squish
    #{WORD_SIMILARITY_QUERY} AS weight
  SQL

  WORD_SIMILARITY_WHERE_QUERY = <<~SQL.squish
    #{WORD_SIMILARITY_QUERY} > 0.1
  SQL

  def search(term)
    query_params = { term: term, begins_with_term: "#{term}%" }

    select_query = sanitize_sql_for_assignment([WORD_SIMILARITY_SELECT_QUERY, query_params])
    where_query = sanitize_sql_for_assignment([WORD_SIMILARITY_WHERE_QUERY, query_params])

    CivilServant
      .distinct
      .joins(:user)
      .select(Arel.star, select_query)
      .where(where_query)
      .order(weight: :desc, first_name: :asc, last_name: :asc)
  end
end
