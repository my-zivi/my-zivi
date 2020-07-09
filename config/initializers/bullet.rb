# frozen_string_literal: true

Bullet.add_whitelist type: :n_plus_one_query, class_name: 'Administrator', association: :organization if defined? Bullet
