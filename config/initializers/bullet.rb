# frozen_string_literal: true

if defined? Bullet
  Bullet.add_whitelist type: :n_plus_one_query, class_name: 'OrganizationMember', association: :organization
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'ServiceSpecification', association: :organization
  Bullet.add_whitelist type: :n_plus_one_query, class_name: 'Organization', association: :organization_members
  Bullet.add_whitelist type: :unused_eager_loading, class_name: 'ExpenseSheet', association: :service
end
