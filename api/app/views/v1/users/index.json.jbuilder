# frozen_string_literal: true

json.array! @users do |user|
  json.extract! user, :id, :zdp, :full_name, :role

  json.beginning((user.active_service || user.next_service)&.beginning)
  json.ending((user.active_service || user.next_service)&.ending)
  json.active user.active?
end
